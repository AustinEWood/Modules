# Hastable to build the modle.
$Gemini = @{
    model = ""
}

# Build API interactions in PowerShell. This will be the base funciton used by all other functions.
function Build-APIInteractions {
    param (
        [string]$ModleName,
        [string]$Method = "GET",
        [string]$CustomURL,
        [switch]$Body
    )

    # Get the API key from the environment variables.
    $APIKey = $env:Google_API

    # Set the base URL for the gemini API.
    $BASE_URL ="https://generativelanguage.googleapis.com/v1beta/$CustomURL`?key=$APIKey"

    # Set the headers for the API request using splatting.
    $headers = @{
        Uri = $BASE_URL
        Method = $Method
        Headers = @{
            "Content-Type" = "application/json"
        }
    }

    # If the Body switch is used, add the body to the headers.
    if ($Body) {
        $headers.Body = $BodyItem
    }

    # Use Splatting to attach all of the paramaters and call the API.
    return Invoke-RestMethod @headers   
}

# Function to start the conversation with the Gemini API.
function Invoke-Conversation {
    param (
        [string]$query,
        [switch]$Retain
    )
    # Check for the retain switch. If this is present the in progress conversation will continue. If not this will start a new conversation.
    if ($Retain){
        $BodyItem = $Conversation | ConvertTo-Json -Depth 5
    }
    else{
        $BodyItem = @{
            "contents" = @{
                "parts" = @{
                    "text" = $query
                }
            }
        } | ConvertTo-Json -Depth 5
    }
       
    # Set the custom URL with the model name and the endpoint for the conversation API.
    $CustomURL = "models/$($Gemini.model):generateContent"
    
    # Call the API and return the response.
    return Build-APIInteractions -Body $BodyItem -Method "POST" -CustomURL $CustomURL
}

# Function to get the tokens from the response.
function Invoke-GetTokens{
    param (
        [object]$GetResponse
    )
    # Get the metadata from the response.
    $metadata = $GetResponse.usageMetadata

    # Get the token counts from the metadata.
    $SentTokens = $metadata.promptTokenCount
    $ReceivedTokens = $metadata.candidatesTokenCount
    $TotalTokens = $metadata.totalTokenCount

    # Format and Return the token counts.
    return "Tokens Count - Sent:$SentTokens Received:$ReceivedTokens Total:$TotalTokens"
}