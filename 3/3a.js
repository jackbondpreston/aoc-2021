const fs = require('fs');

const data = fs.readFileSync("input.txt", "utf8").split("\n");
const width = data[0].length;

const result = data
    .reduce((acc, val) => {
        for (let c = 0; c < width; c++) {
            if (val.charAt(c) === '1') {
                acc[c] += 1;
            }
        }

        return acc;
    }, Array(width).fill(0))
    .map(x => x > (data.length - 1) / 2)
    .reduce((acc, val, index) => {
        if (val) {
            acc += Math.pow(2, (width - index - 1));
        }

        return acc;
    }, 0);

const epsilon = result;
const gamma = ~result & ~(-1 << width);

console.log(epsilon * gamma);

