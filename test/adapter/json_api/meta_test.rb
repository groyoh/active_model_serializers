require 'test_helper'

module ActiveModel
  class Serializer
    class Adapter
      class JsonApi
        class MetaTest < Minitest::Test

          def setup
            ActionController::Base.cache_store.clear
            @post    = Post.new(id: 1, title: 'New Post', body: 'Body')
            @comment = Comment.new(id: 1, body: 'ZOMG A COMMENT')

            @post.comments = [@comment]
            
            serializer = MetaPostSerializer.new(@post)
            @adapter = ActiveModel::Serializer::Adapter::JsonApi.new(serializer, include: "comments")
          end

          def test_meta
            expected = {
              :data => {
                :id => "1",
                :type => "posts",
                :relationships => {
                  :comments => {
                    :data => [
                      {
                        :type => "comments",
                        :id => "1"
                      }
                    ],
                    :meta => {
                      i_am: :relationship
                    }
                  }
                }
              },
              :included => [
                {
                  :id => "1",
                  :type => "comments",
                  :meta => {
                    i_am: :resource
                  }
                }
              ]
            }
            
            assert_equal(expected, @adapter.serializable_hash)
          end
        end
      end
    end
  end
end
