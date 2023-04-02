module Fastlane
    module Actions
        
        COVERAGE_FILE_PATH = 'fastlane/code_coverage/index.html'
        
        class PublishCodeCoverageAction < Action
            def self.run(params)
                UI.message "Generating Slather report"
                Actions::SlatherAction
                .run(
                     scheme: 'Calculator',
                     proj: 'Calculator.xcodeproj',
                     output_directory: "fastlane/code_coverage",
                     html: true
                     )
                     
                     UI.message "Obtaining coverage number"
                     code_coverage = get_code_coverage()
                     UI.message "Code coverage: #{code_coverage}"
                     
                     UI.message "Getting commit SHA"
                     commit_sha = get_current_commit_sha()
                     UI.message "Current commit SHA: #{commit_sha}"
                     
                     UI.message "Publishing coverage on Github"
                     publish_to_github("Code coverage: #{code_coverage}", commit_sha)
            end
            
            def self.get_code_coverage
                # Coverage file path
                current_dir = Dir.pwd
                complete_coverage_file_path = "#{current_dir}/#{COVERAGE_FILE_PATH}"
                UI.message "Coverage file path: #{complete_coverage_file_path}"
                
                # Strings between coverage number
                first_term = "id=\"total_coverage\">"
                second_term = "</span>"
                
                # Check file existence and find coverage
                begin
                    file = File.open(complete_coverage_file_path)
                    file_data = file.read
                    first_string = file_data.split(first_term, -1)[1]
                    final_string = first_string.split(second_term, -1)[0]
                    return final_string
                    rescue Errno::ENOENT
                    return nil
                end
            end
            
            def self.get_current_commit_sha
                commit_info = LastGitCommitAction.run(nil)
                commit_info[:commit_hash]
            end
            
            def self.publish_to_github(message, commit_sha)
                GithubApiAction
                .run(
                     server_url: "https://api.github.com",
                     api_token: ENV["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"],
                     http_method: "POST",
                     path: "/repos/dennymathew/iPadCalculator/statuses/#{commit_sha}",
                     raw_body:"{\"state\":\"success\", \"description\": \"#{message}\", \"context\": \"coverage\"}",
                     error_handlers: {
                     404 => proc do |result|
                     UI.message("Couldn't find resource: #{result[:json]} \n Path: /repos/dennymathew/iPadCalculator/statuses/#{commit_sha} \n Message: #{message}")
                     end,
                     '*' => proc do |result|
                     UI.message("Unknown error: #{result[:json]}")
                     end
                     }
                     ) do |result|
                         UI.message("Code coverage updated for commit #{commit_sha}")
                     end
            end
            
            #####################################################
            # @!group Documentation
            #####################################################
            
            def self.description
                "Publish code coverage to a Github commit status check"
            end
            
            def self.details
                "This action uses Slather to generate a code coverage report for the current Xcode project status, gets the coverage number, gets the current commit and publish the coverage number via Github API to a status check, making it available to see in pull requests, for example"
            end
            
            def self.authors
                ["Denny Mathew"]
            end
            
            def self.is_supported?(platform)
                platform == :ios
            end
        end
    end
end