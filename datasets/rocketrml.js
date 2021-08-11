const parser = require('rocketrml');

// https://github.com/semantifyit/RocketRML
// npm install -g rocketrml
const doMapping = async () => {

    const args = process.argv.slice(2);
    const mapping_path = args[0] || './data/mapping.rml.ttl'
    const output_path = args[1] || './data/bio2kg-rocketml.n3';
    console.log(mapping_path);

    const options = {
        verbose: false,
        toRDF: true,
        // If you want to insert your all objects with their regarding @id's (to get a nesting in jsonld), "Un-flatten" jsonld
        replace: false,
        
        // You can delete namespaces to make the xpath simpler.
        // removeNameSpace: {xmlns:"https://xmlnamespace.xml"},
        // Choose xpath evaluator library, available options: pugixml (cpp xpath implementation, previously xmlPerformanceMode:true) | fontoxpath (xpath 3.1 engine) | default | xpath (same as default)
        xpathLib: "pugixml",
        // xmlPerformanceMode: true,
        // ignore input values that are empty string (or whitespace only) (only use a value from the input if value.trim() !== '') (default false)
        ignoreEmptyStrings: true,

        // You can also use functions to manipulate the data while parsing. (E.g. Change a date to a ISO format, ..)
        functions : {
            'https://w3id.org/um/ids/rmlfunctions.ttl#string_process': function (data) {
                console.log(data);
                s = String(data[0])
                split = data[1]
                prefix = data[2] || null
                find = data[3] || null
                replace = data[4] || null
                format = data[5] || null
                
                if(!s) {
                    return null;
                }
                
                resultList = [];
                if(split) {
                    resultList = s.split(split);
                } else {
                    resultList.push(s);
                }
                
                if(prefix || replace || format) {
                    resultList.forEach(function (value, i) {
                        if(format && format.toLowerCase() == "uri") { 
                            resultList[i] = resultList[i].replace(" ", "-")
                                    .replace(",", "-").replace(".", "-").toLowerCase();
                        }
                        if(format && format.toLowerCase() == "lowercase") {
                            resultList[i] = resultList[i].toLowerCase();
                        }
                        if(format && format.toLowerCase() == "uppercase") {
                            resultList[i] = resultList[i].toUpperCase();
                        }
                        if(prefix) { 
                            resultList[i] = prefix + resultList[i];
                        }
                        if(find && replace) { 
                            resultList[i] = resultList[i].replaceAll(find, replace);
                        }
                    });
                }
                return resultList;
            }
        }
    };
    console.log(mapping_path);
    const result = await parser.parseFile(mapping_path, output_path, options).catch((err) => { console.log(err); });
    console.log(result);
};

doMapping();

// node ../rocketrml.js