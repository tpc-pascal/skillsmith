# Security Policy

## Reporting a vulnerability

Please report security issues via GitHub's private vulnerability reporting
(Security tab -> Report a vulnerability). Do not open public issues for
security bugs.

## Scope

This repository contains an agent skill (markdown), shell scripts and no
runtime services. No secrets or credentials are bundled; CI scans for
accidental leaks. Skills fetched per session run with the user's agent
permissions — review third-party sources before use.
