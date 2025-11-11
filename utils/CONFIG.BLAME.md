# Configuration Blame Analysis Guide

## Introduction

The Configuration Blame Analysis is a systematic methodology designed to trace and attribute every configuration line in a Junos device to its specific commit and author. Similar to Git's `git blame` functionality for source code, this process provides complete visibility into "who changed what, when, and why" in network device configurations.

### Purpose and Benefits

This methodology serves multiple critical purposes:

- **Troubleshooting**: Quickly identify when and by whom problematic configurations were introduced
- **Audit Compliance**: Maintain complete change attribution for regulatory and security requirements  
- **Change Impact Analysis**: Understand the scope and timeline of configuration modifications
- **Knowledge Transfer**: Preserve institutional knowledge about configuration decisions
- **Root Cause Analysis**: Systematically trace configuration issues back to their source

### When to Use This Process

Deploy configuration blame analysis in these scenarios:

- **Post-incident Analysis**: After network outages or performance issues
- **Security Investigations**: When unauthorized or suspicious changes are suspected
- **Compliance Audits**: For regulatory requirements demanding change traceability
- **Configuration Drift Detection**: When comparing current state against baseline
- **Handover Documentation**: During team transitions or vendor changes
- **Preventive Analysis**: Regular reviews of critical configuration sections

---

## Step by Step PROCESS:
 
1. **Commit history**

   Get `commit history` with revisions by executing the following JunOS command:

   ```
   show system commit include-configuration-revision
   ```

   - Retrieves complete chronological commit log
   - Includes configuration revision identifiers for precise tracking
   - Shows author, timestamp, and commit method for each change

2. **Current Configuration Baseline**

   Fetch box currently **active** configuration by executing the following JunOS command:

   ```
   show configuration
   ```

   - Establishes the current state baseline
   - Provides complete running configuration context
   - Serves as reference point for all comparisons

3. **Incremental Change Analysis**

   For each adjacent commit pair, get `exact` changes by executing the following JunOS commands (related to the latest changes (e.g. `L`), previous changes (e.g. `L-1`) and so on (e.g. `L-2`, `L-3`, etc...):

   ```
   show system rollback 0 compare 1
   show system rollback 1 compare 2
   show system rollback N compare N+1
   ```

   - Reveals precise configuration deltas between consecutive commits
   - Shows additions, deletions, and modifications in unified diff format
   - Maintains chronological sequence of changes

4. **Change Attribution and Analysis**
   Analyze `diff` outputs:
   - Parse [edit] sections for exact configuration changes
   - Attribute each config line to the commit that last modified it
 
5. **Report**
   Present blame analysis in a markdown table in hierarchical format:
   - `Author | Rollback | Config Revision | Date | Time | Line | Configuration`
   - Show each config line with proper `indentation` and `line numbers`
   - Use `hierarchical` display format (not set commands)

---

## Technical Implementation Notes

### CRITICAL REQUIREMENTS:
- Use `show system commit include-configuration-revision` for complete history
- Use `compare` commands for accurate diffs between rollback points
- Don't manually compare large config outputs - use `rollback compare`
- Each `diff` shows exactly what changed between commits
- Present results with both `rollback/commit` record and configuration revision string
- Present results in `clear` attribution table format
 
### EXAMPLE COMMANDS:
This is a list of the example commands to run for the analysis:

```bash
show system commit include-configuration-revision
show configuration
show system rollback 0 compare 1
show system rollback 1 compare 2
show system rollback 2 compare 3
```

### REVISION FORMAT:
Configuration revisions follow format: `[RE]-[timestamp]-[sequence]`
**Example:** `re0-1751132126-5` (RE0, timestamp 1751132126, sequence 5)

### OUTPUT FORMAT:

Present results as line-by-line blame table. This is an example:

| Author | Rollback | Config Revision | Date | Time | Change | Configuration Line |
|--------|----------|----------------|------|------|---------|-------------------|
| user1 | 0 | Current | 2025-09-26 | 09:14:04 UTC | **REMOVED** | `protocols isis interface eth0 disable;` |
| user2 | 1 | Previous | 2025-09-26 | 09:12:05 UTC | Modified | `interfaces lo0 unit 0 description "Test";` |

#### Key Table Elements:

- **Author**: User who made the change
- **Rollback**: Rollback number in commit history
- **Config Revision**: Full revision identifier string
- **Date/Time**: When the change was committed
- **Impact**: Assessment of change significance (Critical/Major/Minor)
- **Line**: Configuration line number with proper hierarchical indentation
- **Configuration**: The actual configuration statement

---

## Extended Analysis Sections

### Impact Assessment Framework

After completing the blame analysis, evaluate each configuration change using this framework:

#### Severity Classifications:
- **🔴 CRITICAL**: Changes affecting routing protocols, security policies, or core connectivity
- **🟡 MAJOR**: Interface configurations, VLAN changes, or service modifications  
- **🟢 MINOR**: Descriptions, logging settings, or cosmetic changes

#### Impact Categories:
- **Operational**: Effect on network functionality and performance
- **Security**: Changes to access controls, authentication, or encryption
- **Compliance**: Modifications affecting regulatory or policy requirements
- **Maintenance**: Updates to monitoring, logging, or management functions

### Root Cause Analysis Section

For each significant configuration issue identified:

1. **Timeline Reconstruction**: Map the sequence of changes leading to the issue
2. **Change Correlation**: Identify related modifications across multiple commits
3. **Context Analysis**: Examine surrounding configuration elements for dependencies
4. **Pattern Recognition**: Look for recurring issues or systematic problems

### Recommended Remediation Process

**⚠️ IMPORTANT**

- Before implementing any fixes, always confirm the proposed changes with the user/stakeholder to ensure alignment with business requirements and change management procedures.
- Use only the existing `execute_junos_command` tool for all operations!
- **DO NOT** create blame-specific tools
- **DO NOT** attempt to parse configurations manually
- **DO** orchestrate the entire process with LLM logic and existing tools
- **DO** leverage built-in Junos rollback and compare functionality

This approach ensures compatibility with existing network management workflows while providing comprehensive configuration attribution and analysis capabilities.
