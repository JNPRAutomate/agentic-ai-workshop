# Use Case #8 - Health

## Quick Links
- [Intro](#intro)
- [Summary](#summary)
- [Steps](#steps)
- [Milestones](#milestones)
- [Outcomes](#outcomes)
- [What's next?](#whats-next)

## Intro

This use case demonstrates how an AI agent can be used to check the `health` of our network. Create a document to upload to the `NAF AC4 Project` in Claude Desktop to guide Claude on doing any specific task

This task could be for example to perform a specific test set.

HEALTH.CHECK.md

## Summary

//TODO

## Steps

This section outlines the sequential workflow for completing the use case, combining both `manual verification` steps and `AI-assisted automation prompts`. Each step is designed to build upon the previous one, creating a logical progression from initial environment setup through configuration, validation, and teardown.

- **Manual steps** allow you to observe and verify the AI agent's actions, ensuring transparency and providing learning opportunities to understand what's happening behind the scenes. A few recommendations are provided. Feel free to do them (execute commands, read docs, etc..).
    They are identified as **X. Manual -** (where X is the step number) inside this **Steps** section.
- **AI prompt steps** leverage Claude Desktop with MCP servers to automate complex network operations, demonstrating how natural language instructions can be translated into precise network configurations and operational commands. Copy/Paste the **whole prompt block** into Claude chat.
    They are identified as **X. Prompts -** (where X is the step number) inside this **Steps** section.

By following these steps in order, you'll experience a complete network automation workflow that balances human oversight with AI efficiency, giving you hands-on experience with modern network operations practices while maintaining full visibility and control over the process.

Feel free to test also with your own prompts (at your own risk ⚠️ ) so you can play, test and understand that prompts are one way of providing context to the AI agent and depending on what you write, the AI agent will act in a different way.

This is the list of suggested steps in use case #8:

📢 **Suggestion: Start a new chat for this use case!**

#### 1. Manual - Create a document

You must create a markdown document where you define the health of your network.

This step corresponds to `milestone #1` 🚩.

#### 2. Manual - Upload your document

Your document must be uploaded to the `Projects` section of Claude Desktop application. That way, those `documents`, `code`, or any other `files` added to the project can be used by Claude and being referenced in your chats.

In the application menu, select `Projects`. You can see it here:

![Claude Desktop projects](../images/Claude.Desktop.Projects.png)

You should have already a project named `NAF AC4 workshop` from previous use cases. If not, click on`+ New Project` on the top right corner. Give it a name (e.g. `NAF AC4 workshop`)

![Claude Desktop create project](../images/Claude.Desktop.create.project.png)

Once you got it created, upload your document to the files section. This is an example of how it should look like once it has been added:

![Claude Desktop projects](../images/NAF.AC4.workshop.docs.png)

This step corresponds to `milestone #2` 🚩.

#### 3. Prompt - Deploy topology

📢 **Start a new chat for this use case!**

> 1. Connect to the Linux VM and go to the directory named `/home/claude/workspace/uc8-health/`. This will be your `workspace` for this `use case #8 (Health)`.
> 2. Deploy the container lab topology file (`uc8-health.clab.yml`). No `sudo` required.
> 3. Verify that the state of all the containers from that topology is `running`.
> 4. Do not do anything else.

This step corresponds to `milestone #3` 🚩.

#### 3. Prompt - Run your health check according to your currently written doc

> Follow you the uploaded document **HEALTH.CHECK.md** and issue a health check report of the network.

This step corresponds to `milestone #4` 🚩.

#### 4. Prompt - Destroy the topology

1. 💡tip: This is the end of this use case. Do not destroy the topology if you still want to play a bit until the rest of the people finishes or proctors move the the next one.
2. 💡tip: If you feel comfortable with ContainerLab and Linux, you can **save some tokens** by destroying the topology yourself through the CLI issuing the following commands:

```bash
claude@jcl-ws-vm-01:~ $ gousecase8
claude@jcl-ws-vm-01:~/workspace/uc8-health (main)$ 

claude@jcl-ws-vm-01:~/workspace/uc8-health (main)$ clab destroy -c
11:02:43 INFO Parsing & checking topology file...
11:02:43 INFO Destroying lab name...
11:02:47 INFO Removed container name...
11:02:47 INFO Removing host entries path=/etc/hosts
11:02:47 INFO Removing SSH configs...
claude@jcl-ws-vm-01:~/workspace/uc8-health (main)$ 
```

else, ask the AI agent to do it for you with this prompt:

> 1. Destroy the container lab topology from `use case #8 (Health)` workspace and clean up the environment.
> 2. Do not add any environment cleanup summary.

This step corresponds to `milestone #5` 🚩.

---

📢 **Suggestion: Rename this chat in Claude Desktop App to `UC8 - Health Check`!**

---

## Milestones

These are the milestones accomplished in this use case (either manually or by prompting the AI agent):

1. 🚩 Manual - Create a Markdown document that Claude will use as a guide to check the health of your network.
2. 🚩 Manual - Upload the document to Claude project (e.g. `NAF AC4 Project`)
3. 🚩 Prompt - Ask our AI agent to connect to the Linux server and deploy a Container Lab topology (Linux MCP).
4. 🚩 Prompt - Ask Claude to use the document you create for the purpose you meant.
5. 🚩 Prompt or Manual - Destroy the containerlab topology and clean up the environment.

---

## Outcomes

//TODO

## What's next?

//TODO
