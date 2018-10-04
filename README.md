# staR
#### Statistics and Data Analysis Powered by R

staR is free software for performing basic statistical and data analysis tasks. It is primarily designed as a support tool for teaching introductory courses in data analysis for the social sciences, or other social science courses requiring data analysis tasks.

## Goals
staR’s goals are to provide a software for data analysis with the following characteristics:
#### Easy to use
It should allow users to focus on what is important in social science research (understanding social reality; theory and hypotheses, concepts, research design, indicators, choice of statistical tools) rather than waste time in learning a complex programming language;
#### Easy to be employed in teaching
Rather than requiring to learn and teach complex menu and window systems (looking for options hidden in minor buttons or dialog boxes) it should be based on a simple command syntax with simple options;
also, it should produce output that is easy and consistent to copy and paste across applications (e.g. helping perform assignments);
#### Easy to extend
Instructors should find easy to extend it to implement the statistical procedures they need for their particular course;
#### Standards-based
It should teach students skills that they may reuse, perhaps on professional statistical tools used in the academia and business;
#### Free (and open source)
Students that might only occasionally deal with statistical tools should not be required to buy expensive licenses, nor should departments be forced to make massive license investments on software used for teaching.

## Features
The current version of staR allows users to open datasets and perform basic statistical operations by using the following commands, which act as basic functional equivalents of the same commands supported by the commercial Stata ® software.*

use, browse, tab1, summarize, histogram, tab2, scatter, regress

(* Stata ® is a registered trademark of StataCorp LP.)

## Extensibility
staR is powered by R. In a nutshell, it provides a familiar, easy user interfact that accepts a subset of Stata commands. It then forwards the command syntax to a set of R scripts (one for each implemented command), with output results then collected and visualized in an easy-to-use (also easy to copy and paste) visual form.
As a result, staR is very easy to extend. New commands (meant as functional equivalents of their Stata counterparts) can be easily added by simply adding and R script receving parameters and implementing commands. Given the power of R, the implementation of a command is in most cases a matter of selecting the appropriate package and just performing minimal conversion operations. This allows any instructor with a good knowledge of R to extend the system for their specific teaching purposes.

## Current limitations

#### Functionality
While extensibility (adding new commands) is easy, the current architecture of staR does not provide support for key Stata functionality such as *by*, *if*, *in*, or factor variables (although *i.* notation is supported).

#### Installation
A streamline installation package is not yet available, and some support could be necessary, especially for students with little PC experience. See [installation instructions](setup.html).
