# Copyright (C) 2008 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Rules for running apicheck to confirm that you haven't broken
# api compatibility or added apis illegally.
#

# skip api check for PDK buid
ifeq (,$(filter true, $(WITHOUT_CHECK_API) $(TARGET_BUILD_PDK)))

.PHONY: checkapi

# Run the checkapi rules by default.
droidcore: checkapi

last_released_sdk_version := $(lastword $(call numerically_sort, \
            $(filter-out current, \
                $(patsubst $(SRC_API_DIR)/%.txt,%, $(wildcard $(SRC_API_DIR)/*.txt)) \
             )\
        ))

.PHONY: check-public-api
checkapi : check-public-api

.PHONY: update-api

.PHONY: update-public-api
update-public-api: $(INTERNAL_PLATFORM_API_FILE) | $(ACP)
	@echo Copying current.txt
	$(hide) $(ACP) $(INTERNAL_PLATFORM_API_FILE) frameworks/base/api/current.txt
	@echo Copying removed.txt
	$(hide) $(ACP) $(INTERNAL_PLATFORM_REMOVED_API_FILE) frameworks/base/api/removed.txt

update-api : update-public-api

#####################Check System API#####################
.PHONY: check-system-api
checkapi : check-system-api

.PHONY: update-system-api
update-api : update-system-api

update-system-api: $(INTERNAL_PLATFORM_SYSTEM_API_FILE) | $(ACP)
	@echo Copying system-current.txt
	$(hide) $(ACP) $(INTERNAL_PLATFORM_SYSTEM_API_FILE) frameworks/base/api/system-current.txt
	@echo Copying system-removed.txt
	$(hide) $(ACP) $(INTERNAL_PLATFORM_SYSTEM_REMOVED_API_FILE) frameworks/base/api/system-removed.txt

#####################Check Test API#####################
.PHONY: check-test-api
checkapi : check-test-api

.PHONY: update-test-api
update-api : update-test-api

update-test-api: $(INTERNAL_PLATFORM_TEST_API_FILE) | $(ACP)
	@echo Copying test-current.txt
	$(hide) $(ACP) $(INTERNAL_PLATFORM_TEST_API_FILE) frameworks/base/api/test-current.txt
	@echo Copying test-removed.txt
	$(hide) $(ACP) $(INTERNAL_PLATFORM_TEST_REMOVED_API_FILE) frameworks/base/api/test-removed.txt


endif
