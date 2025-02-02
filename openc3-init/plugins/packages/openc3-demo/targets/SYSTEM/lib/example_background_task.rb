# encoding: ascii-8bit

# Copyright 2022 Ball Aerospace & Technologies Corp.
# All Rights Reserved.
#
# This program is free software; you can modify and/or redistribute it
# under the terms of the GNU Affero General Public License
# as published by the Free Software Foundation; version 3 with
# attribution addendums as found in the LICENSE.txt
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# Modified by OpenC3, Inc.
# All changes Copyright 2022, OpenC3, Inc.
# All Rights Reserved

# This file implements an example background task

require 'openc3/tools/cmd_tlm_server/background_task'

module OpenC3
  # Starts by sleeping 5 seconds then sends up to three collect commands
  class ExampleBackgroundTask < BackgroundTask
    def initialize
      super()
      @name = 'Example Background Task'
      # Create Sleeper here in case the task is stopped before call is executed
      @sleeper = Sleeper.new
    end

    def call
      sent_count = 0
      @sleeper = Sleeper.new
      @status = "Sleeping for 5 seconds"
      return if @sleeper.sleep(5) # allow interfaces time to start
      initial_count = tlm('INST', 'HEALTH_STATUS', 'COLLECTS')
      loop do
        # Start up with at least 3 collects
        count = tlm('INST', 'HEALTH_STATUS', 'COLLECTS')
        if count < (initial_count + 3)
          begin
            cmd('INST', 'COLLECT', 'TYPE' => 'NORMAL', 'DURATION' => 1)
            sent_count += 1
            @status = "Sent COLLECT ##{sent_count} at #{Time.now.sys.formatted}"
            wait("INST HEALTH_STATUS COLLECTS > #{count}", 5)
            @status = "Tlm Updated at #{Time.now.sys.formatted}"
          rescue
            # Oh well - probably disconnected
          end
        else
          break
        end
        return if @sleeper.sleep(1)
      end
      @status = "Finished at #{Time.now.sys.formatted}"
    end

    def stop
      @sleeper.cancel
      @status = "Stopped at #{Time.now.sys.formatted}"
    end
  end
end
