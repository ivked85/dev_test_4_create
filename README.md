# README

  This project was very interesting for me because I've heard about most of the required gems, but never got to try them. As there was no 'one best way' I could find for this project setup, I'll try to use this readme to put more context to why I did what I did, as well as to go over some custom solutions I built to bridge certain gaps.

## Trailblazer v2.1

  For the most part I tried to follow recommended conventions, apart from a few exceptions. 
  
  For example Nick recommends namespacing operations under model's namespace

  ```
  class Project::Create < Trailblazer::Operation
    # stuff
  end
  ``` 
  but that creates some unpredictable issues depending on the order of loaded files, which is messing with reloading in development and also makes weird issues pop-up when re-using operations within operations.
  So I put the operations into their own namespace
  ```
  module Projects::Operations
    class Create < Trailblazer::Operation
      # stuff
    end
  end
  ```
  Also, I wanted to separate operations that are called directly, from the re-used operations that are called as a subprocess within other operations. Name 'task' seemed appropriate, so I put those in Operation::Task namespace.

  One more thing I realized was that when operation inherits from another operation, parent's steps get called first, so I used that to make all operations store their name in context, so it can be used for authentication later.

## Grape API

The file structure as described in [this post](https://www.thegreatcodeadventure.com/making-a-rails-api-with-grap/#:~:text=What%20is%20Grape%3F&text=REST%2Dlike%20API%20micro%2Dframework,DSL%20to%20easily%20provide%20APIs.&text=Installing%20the%20grape%20gem%20in,out%20of%20our%20Rails%20backend) appealed to me the most, so I went with that. What I didn't like was having to do the same thing in every endpoint(call operation, check result, render error or success) I've seen the guys from Trailblazer are working on ```Trailblazer::Endpoint``` that should be able to solve that issue, but it's still mostly work in progress so I went with my own solution. 

I introduced a new convention where a resource, as defined in resource block in grape api for example :projects, expects ```Projects::Operation::#{CrudOperation}``` to be defined, and creates corresponding helper methods to call it. So instead of
```
result = Projects::Operation::Show.(params: params, current_user: current_user)
if result.success?
  # do stuff
else
  error!(result['errors'], result['code'])
end
```
you can do
```
show do |result|
  # do stuff
end
```
API helper that allows for that is ```app/controllers/api/helpers/resource_operations.rb```

Also, what I couldn't figure out was how to return an empty body + code 201 + location header in a nice way so I left it as is
```
header['Location'] = "#{request.url}/#{result['model'].id}"
env['api.format'] = :txt
nil
```

## Fast JSON API serializers

Grape API doesn't seem to support non-default json serialization out of the box. So in order to avoid having to do ```ProjectSerializer.new(project).serialized_json``` in every api endpoint I opted to make it so that a matching serializer from app/serializers is used (if available) when model.to_json is called (if no matching serializer is found the default serialization is used). The code that makes that possible is in ```app/models/concerns/fast_json_serializable.rb```

## Authorizing requests

To avoid repetition when authorizing different requests, I used: 
```
desc do
  named 'name-of-the-request-to-authorize'
end
```
So in before block, request name, along with the user is sent to mocked service for evaluation. ```app/controllers/helpers/authorization.rb``` is responsible for that.

## Authorizing resources

To authorize the resource(s), I presumed the service would need to know user, resource, and the action to authorize. So I created a reusable operation(Task) that passes that info to mocked service. The tricky part was knowing the action, because Authorize operation only has access to context object. That's the reason behind the code in ```base_operation.rb```.

```lib/mock_authorization_service.rb``` is where the separation of project/client, collection/single and authorizing is done, even though I didn't care much for the state of that code, since it's a mock.

## Trying it out

The app is deployed to heroku at ```http://project-browser-dev-test.herokuapp.com```
swagger docs are at ```http://project-browser-dev-test.herokuapp.com/swagger_doc```

I kept sqlite as the development database so it's easier to setup if running the project locally

By default the user is authorized for everything, When testing authorization, request headers ```Unauthorized``` or ```Unauthenticated``` should be set to any value to make the user unauthorized or unauthenticated respectively.