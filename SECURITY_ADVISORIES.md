# Security Advisories
## 2021-06-28 - XXE vulnerability on Launch import with externally-defined DTD file
| Release Date | Affected Projects | Affected Versions | CVE ID(s) | Access Vector| Security Risk |
|--------------|-------------------|-------------------|-----------|--------------|---------------|
| Monday, Jun 28, 2021| [service-api](https://github.com/reportportal/service-api) | Every version, starting from 3.1.0 | [CVE-2021-29620](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-29620) | Remote | High |

### Summary
Starting from version 3.1.0 of the service-api XML parsing was introduced. Unfortunately the XML parser was not configured properly to prevent XML external entity (XXE) attacks. This allows a user to import a specifically-crafted XML file which imports external Document Type Definition (DTD) file with external entities for extraction of secrets from Report Portal service-api module or server-side request forgery. This will be resolved in the 5.4.0 release.

Report Portal versions 5.4+ disable any kind of DTD in XML parser.

### Patch
We advise our users install the latest releases we built specifically to address this issue:
`docker pull reportportal/service-api:5.4.0`

### Contact
[support@reportportal.io](mailto:support@reportportal.io)

## 2020-05-04 - XXE vulnerability in Launch import

| Release Date | Affected Projects | Affected Versions | CVE ID(s) | Access Vector| Security Risk |
|--------------|-------------------|-------------------|-----------|--------------|---------------|
| Monday, May 4, 2020| [service-api](https://github.com/reportportal/service-api) | Every version, starting from 3.1.0 | [CVE-2020-12642](https://nvd.nist.gov/vuln/detail/CVE-2020-12642) | Remote | High |

### Summary
Starting from version 3.1.0 we introduced a new feature of JUnit XML launch import.
Unfortunately XML parser was not configured properly to prevent XML external entity (XXE) attacks.
This allows a user to import a specifically-crafted XML file that uses external entities for extraction of secrets from Report Portal 
service-api module or server-side request forgery.

Report Portal versions 4.3.12+ and 5.1.1+ disable external entity resolution for theirs XML parser.

### Patch
We advise our users install the latest releases we built specifically to address this issue:
* RP v4: `docker pull reportportal/service-api:4.3.12`
* RP v5: `docker pull reportportal/service-api:5.1.1`

### Acknowledgement
The issue was reported to Report Portal Team by an external security researcher.
Our Team thanks Julien M. for reporting the issue.

### Contact
[support@reportportal.io](mailto:support@reportportal.io)
