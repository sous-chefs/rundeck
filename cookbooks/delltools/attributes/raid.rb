# Copyright 2012, Timothy Smith - Webtrends Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# You will need to host the megacli RPM somewhere and set this attribute
default[:delltools][:raid][:megacli_url] = ""
default[:delltools][:raid][:megacli_packagename] = "MegaCli-8.04.07-1.noarch.rpm"

default[:delltools][:raid][:sas2ircu_url] = "http://www.supermicro.com/support/faqs/data_lib/FAQ_9633_SAS2IRCU_Phase_5.0-5.00.00.00.zip"
default[:delltools][:raid][:sas2ircu_packagename] = "FAQ_9633_SAS2IRCU_Phase_5.0-5.00.00.00.zip"