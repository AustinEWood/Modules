# Import the functions to use in the script.
. .\Functions.ps1
# This is a basic conversation. No access to functions or conversation memory.


# Set the model for the Gemini API.
$Gemini.model = "gemini-1.5-flash"

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
        # Call the API and get the response.
        $response = Invoke-Conversation -query $UserMessage

        # Get the token count from the API response.
        $CountTokens = Invoke-GetTokens -GetResponse $response

        # Get the respones from the API.
        $GeminiReturn = $response.candidates.content.parts.text

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