Lucky Luciano, is a library that makes it easy to organize your Sinatra routes into Restful Resources.

You can define Resources with a base route, and then map relative routes in the Resource.
The base route and the relative route are simply merged to create the full route.

    module Resource
      class Users < LuckyLuciano::Resource
        map "/users"

        get "/" do
        end

        get "/:user_id" do
        end

        post "/" do
        end

        put "/:user_id" do
        end

        delete "/:user_id" do
        end
      end

      class UserComments < LuckyLuciano::Resource
        map "/users/:user_id/comments"

        get "/" do
        end

        get "/:comment_id" do
        end

        post "/" do
        end
      end
    end


You can map the Resource to the Sinatra application by registering the route_handler.

    class YourApp < Sinatra::Base
      register(UsersResource.route_handler)
      register(UserCommentsResource.route_handler)
    end

Lucky Luciano also provides a named-route scheme, which is easy to search for in the code-base.
It is rather verbose and ideas are welcome to shorten it, while maintaining searchability and simplicity.

    <a href="<%= Resource::Users.path("/:user_id", :user_id => @user.id, :additional_param => "param 1") %>">Bob</a>
    a "Bob", :href => Resource::Users.path("/:user_id", :user_id => @user.id, :additional_param => "param 1")

    <a href="<%= Resource::UserComments.path("/:comment_id", :user_id => @user.id, :comment_id => @comment.id) %>">Bob's Comment</a>
    a "Bob's Comment", :href => Resource::UserComments.path("/:comment_id", :user_id => @user.id, :comment_id => @comment.id)

Compare with Rails named routes

    <a href="<%= user_path(@user) %>">Bob</a>
    a "Bob", :href => user_path(@user)

    <a href="<%= user_comment_path(@user, @comment) %>">Bob's Comment</a>
    a "Bob's Comment", :href => user_comment_path(@user, @comment)

## Who was this Lucky Luciano person?

Lucky Luciano was a mob boss and an alleged friend of Frank Sinatra.

http://news.bbc.co.uk/2/hi/special_report/1998/05/98/sinatra/94360.stm
