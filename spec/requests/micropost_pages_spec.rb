require 'spec_helper'

describe "MicropostPages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before { sign_in user }

	describe "micropost creation" do
		before { visit root_path }

		describe "with invalid information" do

			it "should not create a micropost" do
				expect { click_button "Post" }.not_to change(Micropost, :count)
			end

			describe "error messages" do
				before { click_button "Post" }
				it { should have_content('error') }
			end
		end

		describe "with valid info" do

			before { fill_in 'micropost_content', with: "lorem ipsum" }
			it "should create a micropost" do
				expect { click_button "Post" }.to change(Micropost, :count).by(1)
			end
		end
	end

	describe "micropost deletion" do
		before { FactoryGirl.create(:micropost, user: user) }

		describe "as correct user" do
			before { visit root_path }

			describe "with valid remember_token" do

				it "should delete a micropost" do
					expect { click_link "delete" }.to change(Micropost, :count).by(-1)
				end
			end

			describe "with expired remember_token" do
				before do
					sign_out
					click_link "delete"
					fill_in "Email",	with: user.email
					fill_in "Password", with: user.password
					click_button "Sign in"
				end

				it "should render the user page" do

					expect(page).to have_title(full_title(''))
				end
			end
		end		
	end
end
