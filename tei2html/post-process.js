const chunks = [];
process.stdin
 .on("data", function(chunk) { chunks.push(chunk) })
 .on("end", function() {
   const text = chunks.join("")
     // Tidy the text...
     .replace(/\s+\n\s+/g, '\n') // Remove spaces around line breaks
     .replace(/\n+/g, '\n') // Collate multiple empty lines
     .replace(/[ ]+/g, ' ') // Collate multiple spaces
     .replace(/\(\s*\n\s*/g, '(') // Clean spacing for opening parenthesis
     .replace(/\s*\n\s*\)/g, ')') // Clean spacing for closing parenthesis
     .replace(/\s*\n*\s*,/g, ',') // Clean spacing for comma
   console.log(text)
 })
 .setEncoding("utf8");
