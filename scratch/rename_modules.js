const fs = require('fs');
const path = require('path');

const modulesDir = path.join(__dirname, '..', 'resources', 'modules');

let totalRenamed = 0;
let totalSkipped = 0;

function processDirectory(dir, pkgName) {
  const entries = fs.readdirSync(dir, { withFileTypes: true });

  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);

    if (entry.isDirectory()) {
      const nextPkg = pkgName || entry.name;
      processDirectory(fullPath, nextPkg);
    } else if (entry.isFile() && entry.name.endsWith('.json')) {
      const filename = entry.name;
      
      // Determine prefix to strip: pkgName_ (case-insensitive)
      let prefixToStrip = null;
      
      if (pkgName && filename.toLowerCase().startsWith(`${pkgName.toLowerCase()}_`)) {
        prefixToStrip = filename.substring(0, pkgName.length + 1);
      } else {
        // Try finding any prefix like XXX_ where XXX matches folder or short pkg name
        const underscoreIdx = filename.indexOf('_');
        if (underscoreIdx > 0) {
          const possiblePrefix = filename.substring(0, underscoreIdx);
          if (pkgName && (possiblePrefix.toLowerCase() === pkgName.toLowerCase() || pkgName.toLowerCase().startsWith(possiblePrefix.toLowerCase()))) {
            prefixToStrip = filename.substring(0, underscoreIdx + 1);
          }
        }
      }

      if (prefixToStrip) {
        const newFilename = filename.substring(prefixToStrip.length);
        if (newFilename && newFilename !== filename) {
          const newPath = path.join(dir, newFilename);
          console.log(`[Rename] ${pkgName}/${filename} -> ${newFilename}`);
          fs.renameSync(fullPath, newPath);
          totalRenamed++;
        } else {
          totalSkipped++;
        }
      } else {
        console.log(`[Keep] ${pkgName}/${filename} (no matching prefix)`);
        totalSkipped++;
      }
    }
  }
}

console.log('--- Renaming Module JSON files in resources/modules ---');
processDirectory(modulesDir, '');
console.log(`\nRenamed ${totalRenamed} files. Skipped ${totalSkipped} files.`);
