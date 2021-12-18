TDAY?=01
DAYS?=$(shell seq -f "%02g" 1 25)
CHALLENGES?=challenge1 challenge2
TMPDIR?=/tmp

.PHONY: run
run:
	@echo "========================================"
	@echo "  Advent of Code 2021 - Mathew Fleisch"
	@echo "========================================"
	@echo
	@$(foreach day, $(DAYS), \
		echo "<============= 2021/12/${day} =============>" \
			&& $(foreach challenge, $(CHALLENGES), \
			echo "#> ./${day}/${challenge}.sh ./${day}/input.txt" \
				&& ./${day}/${challenge}.sh ./${day}/input.txt; ))

.PHONY: run-day
run-day:
	@echo "========================================"
	@echo "  Advent of Code 2021[$(TDAY)] - Mathew Fleisch"
	@echo "========================================"
	@echo
	@echo "<============= 2021/12/${TDAY} =============>" \
			&& $(foreach challenge, $(CHALLENGES), \
			echo "#> ./${TDAY}/${challenge}.sh ./${TDAY}/input.txt" \
				&& DEBUG=1 ./${TDAY}/${challenge}.sh ./${TDAY}/input.txt; )


.PHONY: seed
seed:
	@echo "========================================"
	@echo "  Advent of Code 2021 - Mathew Fleisch"
	@echo "========================================"
	@echo
	@$(foreach day, $(DAYS), \
		echo "<============= Seeding 2021/12/${day} =============>" \
			&& echo "#> mkdir -p ./${day} && touch ./${day}/input.txt" \
			&& mkdir -p ./${day} \
			&& touch ./${day}/input.txt \
			&& $(foreach challenge, $(CHALLENGES), \
			echo "#> echo "#!/bin/bash\necho \"Not Implemented\"" > ./${day}/${challenge}.sh" \
				&& if ! [ -f "./${day}/${challenge}.sh" ]; then \
					echo "#!/bin/bash\necho \"Not Implemented\"" > ./${day}/${challenge}.sh; \
				fi \
				&& echo "#> chmod +x ./${day}/${challenge}.sh" \
				&& chmod +x ./${day}/${challenge}.sh; ))

.PHONY: zip-log
zip-log:
	@mkdir -p $(TMPDIR)/aoc2021-mathew-fleisch-logs
	@cp log-* $(TMPDIR)/aoc2021-mathew-fleisch-logs
	@zip -r $(TMPDIR)/aoc2021-mathew-fleisch-logs.zip $(TMPDIR)/aoc2021-mathew-fleisch-logs