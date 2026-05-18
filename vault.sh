#!/bin/bash
# Print everything above the `---` separator (the password section).
# Falls back to the whole file if there is no separator.
pass show pass | awk '/^---$/{exit} {print}'
