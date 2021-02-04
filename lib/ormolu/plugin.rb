module Danger
  # @example Ensure the files are correctly formatted
  #
  #          ormolu.check files
  #
  # @see  blackheaven/danger-ormolu
  #
  class DangerOrmolu < Plugin

    # Check that the files are correctly formatted
    # @param files [Array<String>]
    #
    def check(files)
      files
        .each { |file|
          result = `ormolu --mode stdout --check-idempotence "#{file}" | diff "#{file}" -`
          unless result.empty?
            extract_diffs(result.lines)
              .each { |diff|
                inconsistence(file, diff[:line], diff[:diff])
              }
          end
        }
    end

    private
    def inconsistence(file, line, diff)
        message = "Style error, fix it through \n\n```haskell\n#{diff}\n``` \n"
        warn(message, file: file, line: line)
    end

    def extract_diffs(lines)
      lines
        .reverse
        .slice_when {|l| l =~ /^\d.*/ }
        .to_a
        .map(&:reverse)
        .reverse
        .map { |chunk|
        {:line => chunk.first[/^\d+/].to_i, :diff => chunk.flatten}
        }
    end
  end
end
