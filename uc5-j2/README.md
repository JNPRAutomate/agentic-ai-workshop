# Use Case #5 - Jinja2 templates

## Quick Links
- [Intro](#intro)
- [Summary](#summary)
- [Steps](#steps)
- [Milestones](#milestones)
- [Outcomes](#outcomes)
- [What's next?](#whats-next)

## Intro

This use case demonstrates how an AI agent can be used for network configuration management with templates. Use or create `jinja2 templates` and render them with some values to apply the configuration generated on your network devices.

### Jinja2

Jinja2 is a templating engine for Python.

Think of it as a smart text generator: you create a template with `variables`, `loops`, and `conditions`, and Jinja2 fills in the blanks with actual data. This data comes from the variables that we will see in the next section.

Here it is a very simple example of a jinja2 template:

```jinja2
set system time-zone {{ timezone }}
```

And here it is an example created in the project:

[Jinja2 time-zone template](./template/timezone_config.j2)

Why use Jinja2 in Automation?

- 📋 Consistency – no typos, all configs follow the same structure.
- ⚡ Speed – generate large configs quickly.
- 🛠️ Automation-ready – integrate with tools like Ansible, Salt, or custom Python scripts.
- 🔄 Flexibility – one template can serve many devices just by swapping the data.

### Variables (YAML)

YAML (YAML Ain’t Markup Language) is a simple, human-readable way to store structured data. Think of it like a clean `text-based` spreadsheet where you define `values`, `lists`, or `hierarchies`.

How it connects to Jinja2 templates?

Jinja2 templates are like `blueprints` of configuration files, with `placeholders` for values.

Instead of hardcoding each value (e.g. an `IP` or `description`), you put variables in the template (`{{ variable }}`).

This way, with one Jinja2 template and YAML files, you can reuse and render configs as you like.

Here it is a very simple example of a YAML file with 2 variables:

```yaml
timezone: Europe/London
```

And here it is an example created in the project:

- [YAML variables](./template/timezone_vars.yml)

### Change configuration

When rendering the configuration 

```
claude@R5> show configuration system time-zone

claude@R5>
```

After the AI agent pushes the configuration, you can see the change being applied:

```
claude@R5> show configuration | compare rollback 1
[edit system]
+  time-zone America/Los_Angeles;

claude@R5>
```

## Summary

After deploying a Container Lab topology with cRPD devices, we will validate the absence of **time-zone** configurations and then leverage AI-assisted template-driven provisioning. The workflow demonstrates rendering configurations from existing **Jinja2 templates** with **YAML** variables, performing **dry-run** validations before deployment, and dynamically generating new templates through the AI agent, showcasing automated configuration management, safe change deployment practices, and the ability to programmatically provision network devices at scale while maintaining configuration consistency across the infrastructure.

## Steps

This section outlines the sequential workflow for completing the use case, combining both `manual verification` steps and `AI-assisted automation prompts`. Each step is designed to build upon the previous one, creating a logical progression from initial environment setup through configuration, validation, and teardown.

- **Manual steps** allow you to observe and verify the AI agent's actions, ensuring transparency and providing learning opportunities to understand what's happening behind the scenes. A few recommendations are provided. Feel free to do them (execute commands, read docs, etc..).
    They are identified as **X. Manual -** (where X is the step number) inside this **Steps** section.
- **AI prompt steps** leverage Claude Desktop with MCP servers to automate complex network operations, demonstrating how natural language instructions can be translated into precise network configurations and operational commands. Copy/Paste the **whole prompt block** into Claude chat.
    They are identified as **X. Prompts -** (where X is the step number) inside this **Steps** section.

By following these steps in order, you'll experience a complete network automation workflow that balances human oversight with AI efficiency, giving you hands-on experience with modern network operations practices while maintaining full visibility and control over the process.

Feel free to test also with your own prompts (at your own risk ⚠️ ) so you can play, test and understand that prompts are one way of providing context to the AI agent and depending on what you write, the AI agent will act in a different way.

This is the list of suggested steps in use case #5:

📢 **Suggestion: Start a new chat for this use case!**

#### 1. Prompt - Deploy topology

> 1. Connect to the Linux VM and go to the directory named `/home/claude/workspace/uc5-j2/`. This will be your `workspace` for this `use case #5 (jinja2 template)`.
> 2. Deploy the container lab topology file (`uc5-j2.clab.yml`). No `sudo` required.
> 3. Verify that the state of all the containers from that topology is `running`.
> 4. Do not do anything else.

This step corresponds to `milestone #1` 🚩.

#### 2. Manual - Connect to the topology routers

Connect directly to the topology routers to inspect and verify their configurations and operational state. 

Issue the following commands in your network:

- show configuration system time-zone

This step corresponds to `milestone #2` 🚩.

#### 3. Prompt - Check if there is any time-zone configured in the network

💡tip: If you want to save some tokens, there is no need to run this step, since it is just going to create a table with its findings.

> Connect to each of the PE devices and create a table showing the configuration related to the `time-zone`. If it is empty, just write `EMTPY`.

This step corresponds to `milestone #3` 🚩.

#### 4. Prompt - Render configuration from template and variables

> 1. Create a simple `Jinja2` template in `set` format for `JunOS` that configures `timezone` with timezone as a variable.
> 2. Use timezone value `America/Los_Angeles` for PE1, PE2 and PE3 and `America/New_York` for PE4, PE5 and PE6.
> 2. Show the configuration rendered.
> 3. Do a `dry-run` at one of the devices (e.g. `pe2`).
> 4. If succeeded, then `push` the configs to all of them.

This step corresponds to `milestone #4` 🚩.

#### 5. Prompt - Destroy the topology

1. 💡tip: This is the end of this use case. Do not destroy the topology if you still want to play a bit until the rest of the people finishes or proctors move the the next one.
2. 💡tip: If you feel confortable with ContainerLab and linux, you can **save some tokens** by destroying the topology yourself through the CLI issuing the following commands:

```bash
claude@jcl-ws-vm-01:~ $ gousecase5
claude@jcl-ws-vm-01:~/workspace/uc5-j2 (main)$ 

claude@jcl-ws-vm-01:~/workspace/uc5-j2 (main)$ clab destroy -c
11:02:43 INFO Parsing & checking topology file...
11:02:43 INFO Destroying lab name...
11:02:47 INFO Removed container name...
11:02:47 INFO Removing host entries path=/etc/hosts
11:02:47 INFO Removing SSH configs...
claude@jcl-ws-vm-01:~/workspace/uc5-j2 (main)$ 
```

else, ask the AI agent to do it for you with this prompt:

> 1. Delete the templates and variable files that you generated in the previous step.
> 2. Destroy the container lab topology from `use case #5 (jinja2 template)` workspace and clean up the environment.
> 3. Do not add any environment cleanup summary.

This step corresponds to `milestone #5` 🚩.

---

📢 **Suggestion: Rename this chat in Claude Desktop App to `UC5 - Jinja2 Templates`!**

---

## Milestones

These are the milestones accomplished in this use case (either manually or by prompting the AI agent):

1. 🚩 Prompt - Ask our AI agent to connect to the Linux server and deploy a Container Lab topology (Linux MCP).
2. 🚩 Manual - Connect to the network of cRPD devices and check that there is no `time-zone` configured.
3. 🚩 Prompt - Check that there is no `time-zone` piece of config provisioned at the devices.
4. 🚩 Prompt - Ask the AI agent to create a Jinja2 template of the `time-zone` and do a dry-run. If succeeded, push it to all devices.
5. 🚩 Prompt or Manual - Destroy the containerlab topology and clean up the environment.

---

## Outcomes

Here there are 2 outcomes when running this use case:

1. The devices must be provisioned with a time-zone (e.g. `America/Los_Angeles`).

```
claude@R1> show system rollback 0 compare 1
[edit system]
+  time-zone America/Los_Angeles;

claude@R1>
```

2. Depending on your new configuration template, the devices will be provisioned with another piece of config related to your template and your variables. If Claude faced any issues due to the different config structure of the cRDP, the changes would be related to the Interfaces descriptions (as suggested in the prompt).

## What's next?

//TODO
