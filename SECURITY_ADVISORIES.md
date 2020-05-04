# Security Advisories
## XXE vulnerability in Launch import

| Release Date | Affected Projects | Affected Versions | CVE ID(s) | Access Vector| Security Risk |
|--------------|-------------------|-------------------|-----------|--------------|---------------|
| Monday, May 4, 2020| [service-api](https://github.com/reportportal/service-api) | Every version, starting from 3.1.0 | TBD | Remote | Medium |

### Summary
Starting from version 3.1.0 we introduced a new feature of JUnit XML launch import.
Unfortunately XML parser was not configured properly to prevent XML external entity (XXE) attacks.
This allows a user to import a specifically-crafted XML file that uses external entities for extraction of secrets from Report Portal 
service-api module or server-side request forgery.

Report Portal versions 4.3.12+ and 5.1.1+ disables external entity resolution for theirs XML parser.

### Patch
We advise our users install the latest releases we built specifically to address this issue:
* RP v4: docker pull reportportal/service-api:4.3.12
* RP v5: docker pull reportportal/service-api:5.1.1

### Acknowledgement
The issue was reported to Report Portal Team by an external security researcher.
Our Team thanks Julien M. for reporting the issue.

### Contact
[support@reportportal.io](mailto:support@reportportal.io)