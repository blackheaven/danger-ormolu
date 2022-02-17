# frozen_string_literal: true

module Danger
  # Lint haskell files against ormolu formatting
  #
  # @example Ensure the files are correctly formatted
  #
  #          ormolu.check files
  #
  # @see  blackheaven/danger-ormolu
  # @tags haskell, formatting, ormolu
  #
  class DangerOrmolu < Plugin
    # Check that the files are correctly formatted
    # @param files [Array<String>]
    # @return [void]
    #
    def check(files, path: 'ormolu', level: :warn)
      files
        .each do |file|
          result = `#{path} --mode stdout --check-idempotence "#{file}" | diff "#{file}" -`
          next if result.empty?

          extract_diffs(result.lines)
            .each do |diff|
              inconsistence(file, diff[:line], diff[:diff], level)
            end
        end
    end

    private

    def inconsistence(file, line, diff, level)
      message = "Style error, fix it through \n\n```haskell\n#{diff.join}\n``` \n"
      send level, message, file: file, line: line
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
