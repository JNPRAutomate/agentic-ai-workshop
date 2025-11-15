# Use Case #7 - Juniper Validated Design (JVD)

## Quick Links
- [Intro](#intro)
- [Summary](#summary)
- [Steps](#steps)
- [Milestones](#milestones)
- [Outcomes](#outcomes)
- [What's next?](#whats-next)

## Intro

This use case demonstrates how an AI agent can automate the replication of Juniper Validated Designs (JVDs) in a virtual environment using ContainerLab and cRPD devices. The goal is to provide a `rapid`, and `cost-effective` way to `validate`, `test`, and `learn` from production-grade network architectures without requiring physical hardware.

For practical implementation in this workshop, we'll work with a **simplified version of the JVD design** — capturing the essential architectural patterns and key configurations while reducing complexity to ensure optimal performance within ContainerLab resource constraints. This approach maintains the core design principles and validation objectives while making the topology more accessible for testing and learning purposes.

### JVD

Juniper Validated Design (`JVD`) is a cross-functional collaboration driven by AWAN Solution Architects and Test teams to develop and validate coherent multidimensional solutions for domain-specific use cases. The scenarios selected for validation are based on industry standards to solve critical business needs with practical network designs that are fully supported and Day-One deployable at publication.

The key goals of the JVD initiative include:

- **TEST** iterative multidimensional use cases.
- **OPTIMIZE** best practices and address solution gaps.
- **VALIDATE** overall solution integrity and resilience.
- **SUPPORT** configuration and design guidance.
- **DELIVER** practical, validated, and deployable solutions.

A reference architecture is selected for validation after ongoing cadence with Juniper global theaters and deep analysis of customer use cases. The design concepts deployed are formulated around best practices, leveraging relevant technologies to deliver the solution scope. Key Performance Indicators (KPI) are identified as part of an extensive test plan that focuses on functionality, performance integrity, and service delivery.

JVDs typically cover scenarios such as:
- Data center architectures (IP Fabric, EVPN-VXLAN)
- Campus and branch networks
- WAN edge and SD-WAN deployments
- Service Provider core and edge networks
- Security architectures

If you want to know more about it go to:

- [JVDs](https://www.juniper.net/documentation/validated-designs/)

## Summary

This workflow demonstrates AI-powered automation that transforms Juniper Validated Design (JVD) documents into live ContainerLab topologies. Starting with a prepared JVD document containing topology diagrams, device inventory, IP addressing, and interface connectivity details, an AI agent extracts the structured data, generates a ContainerLab YAML file, and deploys the topology. After manual review to verify deployment correctness, the AI agent performs cleanup by destroying the topology, completing an end-to-end workflow from design documentation to operational lab environment.

## Steps

This section outlines the sequential workflow for completing the use case, combining both `manual verification` steps and `AI-assisted automation prompts`. Each step is designed to build upon the previous one, creating a logical progression from initial environment setup through configuration, validation, and teardown.

- **Manual steps** allow you to observe and verify the AI agent's actions, ensuring transparency and providing learning opportunities to understand what's happening behind the scenes. A few recommendations are provided. Feel free to do them (execute commands, read docs, etc..).
    They are identified as **X. Manual -** (where X is the step number) inside this **Steps** section.
- **AI prompt steps** leverage Claude Desktop with MCP servers to automate complex network operations, demonstrating how natural language instructions can be translated into precise network configurations and operational commands. Copy/Paste the **whole prompt block** into Claude chat.
    They are identified as **X. Prompts -** (where X is the step number) inside this **Steps** section.

By following these steps in order, you'll experience a complete network automation workflow that balances human oversight with AI efficiency, giving you hands-on experience with modern network operations practices while maintaining full visibility and control over the process.

Feel free to test also with your own prompts (at your own risk ⚠️ ) so you can play, test and understand that prompts are one way of providing context to the AI agent and depending on what you write, the AI agent will act in a different way.

This is the list of suggested steps in use case #7:

📢 **Suggestion: Start a new chat for this use case!**

#### 1. Manual - Fetch JVD documentation

In this first step, you should look for a JVD (Juniper Validated Design) **document** from the [JVDs](https://www.juniper.net/documentation/validated-designs/) library that fits your specific network requirements. Start by selecting **simpler** designs, as complex architectures may exceed token limits when processed by the AI agent. Consider simplifying even basic designs by focusing on core components and removing optional features to ensure the AI can effectively analyze and work with the configuration within its processing constraints. To **ease** this process for you, we will **provide** a specific JVD [link](https://www.juniper.net/documentation/us/en/software/jvd/jvd-metro-ebs-03-03/solution_architecture.html) in **the next step**.

This step corresponds to `milestones #1 and #2` 🚩.

#### 2. Prompt - Fetch JVD documentation and generate topology

> 1. Connect to the Linux VM and go to the directory named `/home/claude/workspace/uc7-jvd/`. This will be your `workspace` for this `use case #7 (JVD)`.
> 2. JVD Documentation Analysis:
> - Access this Juniper Validated Design link: `https://www.juniper.net/documentation/us/en/software/jvd/jvd-metro-ebs-03-03/solution_architecture.html`
> - Extract all necessary information from the `Metro Fabric Architecture` section
> - Focus specifically on the `Metro Fabric` (orange region) and `Metro Core` (grey region) components
> - Pay close attention to the topology diagrams, especially Figure 14 - Metro Fabric Architecture
> - Identify all node `types`, their `roles`, `interconnection` patterns, `redundancy` mechanisms, and `high availability` features
> 3. Container Lab Topology Creation
> - Create a Container Lab topology file named `uc7-jvd.clab.yml` in the workspace
> - Critical Requirements:
>   - Use only `JunOS cRPD containers` with image `25.2R1.9`
>   - Do not include any complex fields like `binds`, `ports`, `cmd`, or `env` in node configurations
>   - Keep it simple: only include `kind`, `image` and `mgmt-ipv4` for each node
>   - Use standard Container Lab management network settings
> 4. Node Type Organization and IPv4 Addressing
> - Organize IPv4 addresses (`mgmt-ipv4`) by node type for easy `identification` and `management`:
>   - Metro Fabric Nodes:
>     - Access Leaf nodes (AN): `172.20.20.1x` (x = 1, 2, 3, 4...)
>     - Lean Spine nodes (AG): `172.20.20.2x` (x = 1, 2...)
>     - Metro Edge Gateway nodes (MEG): `172.20.20.3x` (x = 1, 2...)
>   - Metro Core Nodes:
>     - Core Routers (CR): `172.20.20.4x` (x = 1, 2...)
> 5. Do not do anything else.

This step corresponds to `milestones #3 and #4` 🚩.

#### 3. Prompt - Deploy topology

> 1. Deploy the container lab topology file (`uc7-jvd.clab.yml`) you just created. No `sudo` required.
> 2. Verify that the state of all the containers from that topology is `running`.
> 3. Do not do anything else.

This step corresponds to `milestone #5` 🚩.

#### 4. Manual - Review the topology

Review the topology generated with the ContainerLab `topoviewer` plugin from VSCode (recommended). Else, you can go to the workspace directory directory named `/home/claude/workspace/uc7-jvd/` and issue the following command:

```bash
$ clab graph
11:41:53 INFO Parsing & checking topology file=uc7-jvd.clab.yml
11:41:53 INFO Serving topology graph
  addresses=
  │   http://10.83.152.143:50080
  │   http://172.19.0.1:50080
  │   http://172.17.0.1:50080
  │   http://172.20.20.1:50080
```

Open a browser and go to your VM address (top one) and there you will see your network topology diagram (you might require port forwarding).

This step corresponds to `milestone #6` 🚩.

#### 5. Prompt - Destroy the topology

1. 💡tip: This is the end of this use case. Do not destroy the topology if you still want to play a bit until the rest of the people finishes or proctors move the the next one.
2. 💡tip: If you feel comfortable with ContainerLab and Linux, you can **save some tokens** by destroying the topology yourself through the CLI issuing the following commands:

```bash
claude@jcl-ws-vm-01:~ $ gousecase7
claude@jcl-ws-vm-01:~/workspace/uc7-jvd (main)$ 

claude@jcl-ws-vm-01:~/workspace/uc7-jvd (main)$ clab destroy -c
11:02:43 INFO Parsing & checking topology file...
11:02:43 INFO Destroying lab name...
11:02:47 INFO Removed container name...
11:02:47 INFO Removing host entries path=/etc/hosts
11:02:47 INFO Removing SSH configs...

# Do not run below commands if you want to keep the topology
claude@jcl-ws-vm-01:~/workspace/uc7-jvd (main)$ rm -f uc7-jvd.clab.yml 
claude@jcl-ws-vm-01:~/workspace/uc7-jvd (main)$ 
claude@jcl-ws-vm-01:~/workspace/uc7-jvd (main)$ rm -f uc7-jvd.clab.yml.annotations.json
claude@jcl-ws-vm-01:~/workspace/uc7-jvd (main)$ 
```

else, ask the AI agent to do it for you with this prompt:

> 1. Destroy the container lab topology files from `use case #7 (JVD)` workspace (both `yml` and `json`) and clean up the environment.
> 2. Do not add any environment cleanup summary.

This step corresponds to `milestone #7` 🚩.

---

📢 **Suggestion: Rename this chat in Claude Desktop App to `UC7 - JVD`!**

---

## Milestones

These are the milestones accomplished in this use case (either manually or by prompting the AI agent):

1. 🚩 Manual - Obtain a JVD document (markdown or Word format) of a simple design.
2. 🚩 Manual - Review JVD document
3. 🚩 Prompt - Ask the AI agent to digest that document to extract topology data
4. 🚩 Prompt - Generate ContainerLab topology YAML file and review file structure
5. 🚩 Manual - Deploy generated topology file
6. 🚩 Manual - Review generated topology diagram (VSCode Containerlab plugin or topology graph)
7. 🚩 Prompt or Manual - Destroy the containerlab topology and clean up the environment.

---

## Outcomes

//TODO

## What's next?

//TODO
