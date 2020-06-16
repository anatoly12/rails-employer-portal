# Overflow extra: Allow for easy handling of overflowing pages
# See https://ddnexus.github.io/pagy/extras/overflow
require "pagy/extras/overflow"
Pagy::VARS[:overflow] = :last_page
