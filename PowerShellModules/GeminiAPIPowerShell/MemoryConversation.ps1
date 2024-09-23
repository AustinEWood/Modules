# Import the functions to use in the script.
. .\Functions.ps1

# This is a full conversation with memory. As of now the token count can get very long. This will only go higher the longer the conversation goes on. I am working on changing this soon.

# Set the model for the Gemini API.
$Gemini.model = "gemini-1.5-flash"

# Check if the conversation file exists. If it does, load the conversation. If not, create a new conversation.
if (Test-Path -Path .\Conversation.json) {
    # Load the conversation from the file.
    $PastConversation = Get-Content -Path .\Conversation.json | ConvertFrom-Json

    # Create a hash table to store the conversation.
    $Conversation = @{
        "contents" = $PastConversation.contents
    }
}
else {
    # Create a hash table to store the conversation.
    $Conversation = @{
        "contents" = @()
    }
}

# Start the conversation.
write-host "Hello I am Gemini How can I help you?"

# Get the user input.
$UserMessage = Read-Host "User"

# Start the conversation loop.
while ($true) {
    # If the user types "exit", break the loop.
    if ($UserMessage -eq "exit") {
        # Break the loop.
        break
    }
    elseif ($UserMessage -eq "clear") {
        # Clear the console.
        Clear-Host

        # Get the user input.
        $UserMessage = Read-Host "User"
    }
    else {

        # Create a hash table to store the conversation.
        $UserConversation = [ordered]@{
            "role" = "user"
            "parts" = @{
                "text" = $UserMessage
            }
        }

        # Add the user message to the conversation.
        $Conversation.contents += $UserConversation

        # Check if the conversation already started.
        if ($Conversation.contents.Count -lt 1) {
            # Call the API and get the response.
            $response = Invoke-Conversation -query $UserMessage
        }
        else {
            # Call the API and get the response.
            $response = Invoke-Conversation -query $Conversation -Retain
        }

        # Get the respones from the API.
        $GeminiReturn = $response.candidates.content.parts.text

        # Get the token count.
        $CountTokens = Invoke-GetTokens -GetResponse $response

        # Create a hash table to store the conversation.
        $GeminiConversation = [ordered]@{
            "role" = "model"
            "parts" = @{
                "text" = $GeminiReturn
            }
        }

        # Add the Gemini message to the conversation.
        $Conversation.contents += $GeminiConversation

        # Write a blank line to the console. To put a space between the user and Gemini responses.
        write-host ""

        # Write the response to the console.
        write-host "Gemini: $GeminiReturn"

        # Write the token count to the console.
        write-host "$CountTokens"

        # Get the user input.
        $UserMessage = Read-Host "User"
    }
}

# Save the conversation to a file.
$Conversation | ConvertTo-Json -Depth 5 | Out-File -FilePath "conversation.json"