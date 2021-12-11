const fs = require('fs');

const data = fs.readFileSync("input.txt", "utf8").split("\n");
data.pop();
const width = data[0].length;

let results = [0, 0];
let filtered;

for (let x = 0; x <= 1; x++) {
    filtered = data;
    for (let i = 0; i < width && filtered.length > 1; i++) {
        const numOnes = filtered
            .reduce((acc, val) => {
                if (val.charAt(i) === x.toString()) {
                    acc += 1;
                }
                return acc;
            }, 0);
        
        let keep = x.toString();
        if (numOnes < filtered.length / 2) keep = '0';
        if (numOnes > filtered.length / 2) keep = '1';

        filtered = filtered
            .filter(x => x.charAt(i) === keep);
    }
    results[x] = parseInt(filtered[0], 2);
}


console.log(results.reduce((x, y) => x * y));
