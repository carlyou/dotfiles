const fs = require("node:fs");

function formatTokens(count) {
  if (count >= 999950000) {
    return `${(count / 1e9).toFixed(1)}b`;
  }
  if (count >= 999950) {
    return `${(count / 1e6).toFixed(1)}m`;
  }
  if (count >= 1000) {
    return `${(count / 1e3).toFixed(1)}k`;
  }
  return count.toString();
}

function tokenCount(value) {
  return typeof value === "number" && Number.isFinite(value) ? value : 0;
}

try {
  const status = JSON.parse(fs.readFileSync(0, "utf8"));
  const lines = fs.readFileSync(status.transcript_path, "utf8").split("\n");
  const entries = [];
  let hasStopReason = false;

  for (const line of lines) {
    if (!line) {
      continue;
    }
    try {
      const entry = JSON.parse(line);
      if (entry?.message?.usage) {
        entries.push(entry);
        hasStopReason ||= Object.hasOwn(entry.message, "stop_reason");
      }
    } catch {}
  }

  const completedEntries = hasStopReason
    ? entries.filter((entry, index) =>
        Boolean(entry.message.stop_reason) ||
        (entry.message.stop_reason === null && index === entries.length - 1),
      )
    : entries;

  let uncachedInput = 0;
  let output = 0;
  let cacheRead = 0;
  let cacheCreation = 0;

  for (const entry of completedEntries) {
    const usage = entry.message.usage;
    uncachedInput += tokenCount(usage.input_tokens);
    output += tokenCount(usage.output_tokens);
    cacheRead += tokenCount(usage.cache_read_input_tokens);
    cacheCreation += tokenCount(usage.cache_creation_input_tokens);
  }

  const cachedInput = cacheRead + cacheCreation;
  const input = uncachedInput + cachedInput;
  const total = input + output;
  const cacheableInput = cacheRead + cacheCreation;
  const cacheHitRate = cacheableInput > 0 ? (cacheRead / cacheableInput) * 100 : 0;

  process.stdout.write(
    `${formatTokens(input)}/${formatTokens(output)}/${formatTokens(total)}/${cacheHitRate.toFixed(1)}%`,
  );
} catch {}
