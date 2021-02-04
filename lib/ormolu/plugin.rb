# frozen_string_literal: true

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
        .each do |file|
          result = `ormolu --mode stdout --check-idempotence "#{file}" | diff "#{file}" -`
          next if result.empty?

          extract_diffs(result.lines)
            .each do |diff|
              inconsistence(file, diff[:line], diff[:diff])
            end
        end
    end

    private

    def inconsistence(file, line, diff)
      message = "Style error, fix it through \n\n```haskell\n#{diff}\n``` \n"
      warn(message, file: file, line: line)
    end

    def extract_diffs(lines)
      lines
        .reverse
        .slice_when { |l| l =~ /^\d.*/ }
        .to_a
        .map(&:reverse)
        .reverse
        .map do |chunk|
          { line: chunk.first[/^\d+/].to_i, diff: chunk.flatten }
        end
    end
  end
end
