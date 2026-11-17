#!/usr/bin/env node
// Formats the file Claude just edited with Prettier.
// Only runs when the project has Prettier installed (node_modules/prettier).
// Works the same on Windows, Ubuntu and Arch because it only depends on Node.

const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');

const EXTENSIONS = /\.(js|jsx|ts|tsx|mjs|cjs|css|scss|html|json|md|yml|yaml)$/i;

let input = '';
process.stdin.on('data', (chunk) => (input += chunk));
process.stdin.on('end', () => {
  try {
    const data = JSON.parse(input);
    const file = data.tool_input && data.tool_input.file_path;
    if (!file || !EXTENSIONS.test(file)) return;

    const root = process.env.CLAUDE_PROJECT_DIR || data.cwd || process.cwd();
    if (!fs.existsSync(path.join(root, 'node_modules', 'prettier'))) return;

    spawnSync('npx', ['--no-install', 'prettier', '--write', file], {
      cwd: root,
      stdio: 'ignore',
      shell: process.platform === 'win32',
    });
  } catch (_) {
    // A formatting hook must never block Claude.
  }
});
