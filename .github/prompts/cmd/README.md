
## Copilot Hash Commands

<!--
Slash Command,/,"Action/Utility: Used to invoke built-in functions, change settings, or delegate tasks. 
These are agent-level commands that are executed by Copilot.",/delegate (to hand off work)
--> 

#prompt:cmd/{name}	Executes a predefined command prompt template located in the `.github/prompts/cmd/` directory.
 
Available command prompts in the `.github/prompts/cmd/` directory with brief descriptions.
### [Meta Prompting](https://github.com/glittercowboy/taches-cc-prompts/tree/main/meta-prompting)
 - #prompt:create-prompt - Generates a new reusable prompt file in the `.github/prompts/` directory based on user specifications.
 - #prompt:run-prompt    - Executes a specified prompt file from the `.github/prompts/` directory, delegating the task to a sub-agent for processing.
### [Todo Management](https://github.com/glittercowboy/taches-cc-prompts/tree/main/todo-management)
 - #prompt:add-to-todos	- Adds a new todo item to the `TO-DOS.md` file using context from the current conversation.
 - #prompt:check-todos  - Displays a list of existing todo
### [Context Handoff](https://github.com/glittercowboy/taches-cc-prompts/tree/main/context-handoff)
 - #prompt:context-handoff -  Facilitates the transfer of conversation context to another agent or tool for specialized processing.

Hash Command #

Context/Reference: 
Used to inject specific external content or files into the current prompt. 
These modify the context sent to the model.,#prompt: (to load a template)





For more prompts and information, visit
https://github.com/glittercowboy/taches-cc-prompts




