---
name: writing-style
description: Pulkit's writing style for docs, writeups, review docs, exec/leadership narratives, and Slack posts. Produces concise, data-driven, human-sounding prose with no AI tells. Use whenever writing or editing any prose document, doc section, review bullet, or message on Pulkit's behalf, or when asked to humanize / de-slop / tighten a draft.
---

# Writing Style

Write the way Pulkit writes: direct, precise, data-first, and human. The reader should hear a person who owns and understands the content, not an AI. When editing an existing draft, preserve every fact, number, name, and file path.

This skill is the standard. If it conflicts with a generic "be thorough" instinct, this skill wins.

It also overrides any terse or concise-output style when producing an authored artifact or a message meant for another reader. Write full, publishable prose there regardless of the active conversational style. A compression style may govern chat replies to Pulkit, never a document, review, or Slack post written on his behalf.

North star: write varied, imperfect, specific. Any single pattern below used once is usually fine. The tell is many of them together, or one repeated.

## Hard rules (these are the ones Pulkit corrects most)

1. **Exact numbers, never ranges or fractions of counts.** We ran the experiment, so state the value. Write "T2 SP clicks +0.27%", not "around +0.3%" or "4 of 5 arms improved".
2. **No fluff.** Cut narrative intros, throat-clearing, and editorializing one-liners. Delete openers like "In today's landscape" and closers like "The engagement thesis held; the economics did not". Lead with the message and the data.
3. **No em-dashes.** Do not use `--` or the em-dash character. Use a comma, a period, or a colon, or restructure the sentence.
4. **Simple language for executives.** An exec should get the point on one read. Remove jargon and complex constructions.
5. **Match a reference document exactly when told to.** Same section order, same table columns, same structure. Do not add or drop sections. Verify parity against the reference before finishing.

## Ban list

Never use these unless quoting a source or naming a real API/metric.

- AI-slop words: delve, leverage, robust, seamless, ecosystem, utilize, empower, unlock, elevate, foster, realm, landscape, testament, tapestry, underscore, pivotal, crucial, notably, arguably, quietly, deeply, fundamentally, remarkably, streamline, harness, synergy, paradigm, framework.
- Weasel words: nearly, basically, simply, just, very, really, quite, essentially, fairly, somewhat.

## Structural anti-patterns

Avoid these constructions (adapted from tropes.fyi and Pulkit's own corrections):

- The "A, not B" negative parallelism ("This refines, not overhauls"; "Not X. Not Y. Just Z.").
- The rule-of-three tricolon ("faster, cleaner, and more reliable").
- Trailing "does NOT do X" sentences after explaining what something does.
- Question-then-answer padding ("Why does this matter? It matters because...").
- Announce-then-answer preamble and reasoning leaks ("Let me break this down", "Let's unpack this").
- The tie-back: looping back to restate the question after you already answered it.
- Signposted conclusions ("In conclusion", "To sum up", "In summary").
- Fractal summaries: every section and subsection getting its own recap.
- Grandiose stakes inflation, and quotable one-liners that carry no information.
- Vague attributions ("experts say", "studies show", "industry reports") with no named source.
- The "serves as / represents / stands as / marks" dodge instead of plain "is".
- False-suspense transitions ("Here's the kicker", "Here's the thing", "But here's the catch").
- Starting many sentences with "Additionally", "Moreover", "Furthermore".

## Formatting

- No Title Case Headings. Use sentence case.
- No bold-first bullets where every item opens with a bolded phrase, unless it is a genuine term-and-definition list.
- No decorative unicode (arrows, curly/smart quotes). Plain ASCII.

## Sentence and structure rules

- One idea per paragraph. The first sentence carries the point.
- Aim under 30 words per sentence. Prefer active voice.
- Replace adjectives with data. Not "a large improvement", but "+195 bps".
- Apply the "So what?" test to every sentence. If it does not inform a decision, cut it.
- Do not over-bullet. Use prose for reasoning and reserve bullets for genuine lists. If everything is a bullet, nothing stands out.

## Exec and review documents

- **STAR framing** for deliverables. Make the Situation's ambiguity or complexity explicit, then in Behavior show specifically how Pulkit resolved it or steered the product, then the measurable Result.
- Put the number and the decision first, the mechanism second, the caveat last.
- Expect multiple passes. Draft, then run the review loop below, then hand back for Pulkit's own edit.

## Writing for a VP or a reader outside the team

- **Readable cold.** Assume no context. Spell out acronyms and internal names, or replace them with plain descriptions ("the share of searches where the first ad is not an exact match", not "MRP1"). Keep a short term only if the doc's Terminology section defines it (e.g. TOP / MOP), and then use it consistently.
- **Precise words, no loose metaphors.** Name what is measured. Write "the predicted irrelevance of the worst candidates (99th percentile) and how far they sit above a typical one (99th percentile minus the median)", not "how messy the pool is". A stand-in word that changes the meaning (e.g. "proportion of irrelevant ads" for a percentile) is a factual error.
- **Concise without dropping detail.** Shorten sentences and cut filler, but keep the numbers and the mechanism that support each claim.
- **Explain ratios and comparisons.** Do not leave a reader to decode "8.3% of ads but 27.6% of mismatches". Say why it matters: "This band is small: only 8.3% of first-position ads fall in it. Yet it produces 27.6% of all non-exact matches."
- **Match the surrounding doc.** When adding a section, copy the voice, terms and level of detail of the sections around it.
- **Examples serve the story.** Pick the examples that support the doc's narrative, lead each with a short plain title, and drop ones that dilute it. Prefer "the agent reasons about X and decides Y; for example, in experiment N it..." over a list of abstract rules.
- **Verb choice.** Prefer plain, confident verbs ("reasons", "found", "chose") over hedged or colloquial ones ("works out", "figures out").
- **Format on request.** If asked for a paragraph, write one paragraph; if asked for bullets, use bullets. Offer 2 to 3 title options when asked for a title, with a recommendation.

## Accuracy and sourcing in authored docs

- **Every claim traces to a source the reader can follow.** Cite only experiments, docs or results the doc itself links. Verify numbers and quotes against the source logs before writing them.
- **Never invent to fit the narrative.** If the requested framing conflicts with the record (who proposed an idea, which test was run, a number that is not in the logs), write the accurate version and flag the conflict in one line.
- **Keep comparisons like for like.** Do not compare an offline estimate with an online read, or mix basis points and percentage points in one comparison. Label offline vs online and keep one unit per comparison.
- **Estimates are labelled.** Measured results get exact numbers (hard rule 1). A derived estimate (e.g. time saved) uses "about" and states its assumption once.
- **Credit precisely.** Say which steps the human directed and which the agent did. When the record shows the human set a direction, say so; when it is unknown, do not guess.

## Process: draft then self-review (do not one-shot)

One-shot generation is where AI tells leak in. After drafting:

1. Reread against the Hard Rules and Ban List. Fix every violation.
2. Reread for the "So what?" test and cut sentences that fail it.
3. If matching a reference doc, diff the structure and confirm parity.
4. For exec docs, reread as a reader with no context: every term defined or replaced, every number sourced and like for like.
5. Report what you changed in one line, then present the draft.

## Further references (external, optional)

- `aim plugins install AWSWritingGuide` (AWS style + humanizer, maintained slop-word list).
- `amazon-writing` skill in AIPowerUserCapabilities; `amazon-narrative-writing.md`.
- tropes.fyi/tropes-md for a broader AI-tells list; `vale` + `vale-ai-tells` as a prose linter for repos.
