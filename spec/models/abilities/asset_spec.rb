require 'spec_helper'
require 'cancan/matchers'

describe Asset do
  %w( image upload ).each do |asset_type|

    describe 'abilities' do
      subject { ability }
      let(:ability){ Ability.new(user) }

      describe "for classroom #{asset_type}" do
        let(:asset){ Fabricate(asset_type.to_sym) }

        context 'and a visitor' do
          let(:user){ User.new }

          it{ should_not be_able_to(:create, Fabricate.build(
            asset_type.to_sym, :user => user, :classroom => asset.classroom))
          }
          it{ should_not be_able_to(:index, asset) }
          it{ should_not be_able_to(:detroy, asset) }
        end

        context 'and a member' do
          let(:user){ Fabricate(:user) }
          before do
            classroom = asset.classroom
            classroom.members << user
            classroom.save
          end

          it{ should be_able_to(:create, Fabricate.build(
            asset_type.to_sym, :user => user, :classroom => asset.classroom))
          }
          it{ should_not be_able_to(:index, asset) }
          it{ should_not be_able_to(:destroy, asset) }
        end

        context 'and a collaborator' do
          let(:user){ Fabricate(:user) }
          before do
            classroom = asset.classroom
            classroom.collaborators << user
            classroom.save
          end

          it{ should be_able_to(:create, Fabricate.build(
            asset_type.to_sym, :user => user, :classroom => asset.classroom))
          }
          it{ should be_able_to(:index, asset) }
          it{ should be_able_to(:destroy, asset) }
        end

        context 'and a non-member' do
          let(:user){ Fabricate(:user) }

          it{ should_not be_able_to(:create, Fabricate.build(
            asset_type.to_sym, :user => user, :classroom => asset.classroom))
          }
          it{ should_not be_able_to(:index, asset) }
          it{ should_not be_able_to(:destroy, asset) }
        end
      end

    end

  end #each
end
