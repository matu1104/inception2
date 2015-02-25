
FactoryGirl.define do
  factory :user do
    username 'user1'
    email 'user1@mysite.com'
    password Devise.bcrypt(User, 'passw0rd!')
    admin false
  end

  factory :admin, class: User do
    username 'admin'
    email 'admin@mysite.com'
    password Devise.bcrypt(User, 'passw0rd!')
    admin true
  end
end
