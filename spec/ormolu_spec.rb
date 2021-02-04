require File.expand_path("../spec_helper", __FILE__)

module Danger
  describe Danger::DangerOrmolu do
    it 'should be a plugin' do
      expect(Danger::DangerOrmolu.new(nil)).to be_a Danger::Plugin
    end

    #
    # You should test your custom attributes and methods here
    #
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @ormolu = @dangerfile.ormolu
        allow(@ormolu.git).to receive(:added_files).and_return([])
        allow(@ormolu.git).to receive(:modified_files).and_return([])
      end

      # Some examples for writing tests
      # You should replace these with your own.

      it 'collects Warnings' do
        expect(@ormolu).to receive(:warn).exactly(4).times
        @ormolu.check([File.expand_path('spec/fixtures/HaskellTestFile.hs')])
      end
    end
  end
end
