# sparqler
multiple triple store sparql request edition and execution

- Use VS Code to edit the requests with syntax highlighting
- define tasks for executing the requests

# installed exensions

- [stardog-union.stardog-rdf-grammars](https://marketplace.visualstudio.com/items?itemName=stardog-union.stardog-rdf-grammars) syntax highlighter

# dependencies

- install [jena](https://jena.apache.org/) and configure your PATH to point to it folder containing the tools rsparql, rdfdiff, riot, ...

# edit your queries

- in simple files with a `.rq` or `.sparql` name exension

# execute them

- define tasks in `.vscode/tasks.json`
- apply them directly while editing the request by saving the file to disk and calling the task with the short keys `Ctrl-Maj-B` 