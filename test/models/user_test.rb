require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                      password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn foobar@foo.bar.com]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email address should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email address should be downcased" do
    bad_address = "fooBAR@foobar.COM"
    @user.email = bad_address
    @user.save
    assert_equal @user.reload.email, bad_address.downcase
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow adn unfollow a user" do
    steve = users(:steve)
    archer = users(:archer)
    assert_not steve.following?(archer)
    steve.follow(archer)
    assert steve.following?(archer)
    assert archer.followers.include?(steve)
    steve.unfollow(archer)
    assert_not steve.following?(archer)
    # Users can't follow themselves
    steve.follow(steve)
    assert_not steve.following?(steve)
  end

  test "feed should have the right posts" do
    steve = users(:steve)
    archer = users(:archer)
    lana = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert steve.feed.include?(post_following)
    end
    # Self-posts for user with followers
    steve.microposts.each do |post_self|
      assert steve.feed.include?(post_self)
    end
    # Posts from non-followed user
    archer.microposts.each do |post_unfollowed|
      assert_not steve.feed.include?(post_unfollowed)
    end
  end
end
