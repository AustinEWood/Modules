The project is focused around working with the Gemini API using restmethod in PowerShell. 

You will need to get an API key from Google AI Studio. It is free and all you will need for this project to work. There is a limit to the free API key, but it is more than enough for this project.

You can get an API key here:
https://makersuite.google.com/app/apikey

Documentation for the API can be found here:
https://ai.google.dev/aistudio


The Conversation.ps1 script will allow you to start a conversation. But there will be no memory with this conversation. MemoryConversation.ps1 will let you have a conversation the keeps track of the conversation. As of now, the whole conversation is sent each time. This is not ideal, but it is a start.

The token count can get high fast. I have not seen any latency issues, as of now. But this will cause you to hit the limit of the free API key faster.

I am working on a fix for this. I will update the project when I have a solution soon.

Currently the project is run using scripts. This will be changing to a module soon.