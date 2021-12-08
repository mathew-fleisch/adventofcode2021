DAYS?=$(shell seq -f "%02g" 1 25)
CHALLENGES?=challenge1 challenge2

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
				&& DEBUG=1 ./${day}/${challenge}.sh ./${day}/input.txt; ))


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