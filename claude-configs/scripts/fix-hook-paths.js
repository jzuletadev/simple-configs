// Makes hook commands installed by claude-code-templates work from any directory.
// The templates write "python .claude/hooks/x.py" (relative to the project), which
// fails whenever Claude Code runs outside the home folder. This rewrites those
// commands to an absolute path under ~/.claude/hooks. Safe to rerun.
const fs = require('fs');
const os = require('os');
const path = require('path');

const claudeDir = path.join(os.homedir(), '.claude');
const hooksDir = path.join(claudeDir, 'hooks').split(path.sep).join('/');
const relative = /(^|\s)\.claude[\\/]hooks[\\/]([^\s"']+)/g;

function fix(command) {
  return command.replace(relative, (_, lead, file) => `${lead}"${hooksDir}/${file}"`);
}

function walk(node, state) {
  if (Array.isArray(node)) return node.forEach((n) => walk(n, state));
  if (!node || typeof node !== 'object') return;
  if (typeof node.command === 'string') {
    const fixed = fix(node.command);
    if (fixed !== node.command) { node.command = fixed; state.changed = true; }
  }
  Object.values(node).forEach((n) => walk(n, state));
}

for (const name of ['settings.json', 'settings.local.json']) {
  const file = path.join(claudeDir, name);
  if (!fs.existsSync(file)) continue;
  let json;
  try { json = JSON.parse(fs.readFileSync(file, 'utf8')); } catch (e) {
    console.warn(`Skipped ${file}: not valid JSON (${e.message})`);
    continue;
  }
  const state = { changed: false };
  walk(json.hooks, state);
  if (state.changed) {
    fs.copyFileSync(file, `${file}.bak-hooks`);
    fs.writeFileSync(file, JSON.stringify(json, null, 2) + '\n');
    console.log(`Fixed hook paths in ${file}`);
  }
}
