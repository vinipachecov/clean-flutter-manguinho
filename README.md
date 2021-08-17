# clean_flutter_manguinho

This project is the follow on code of the course: "Flutter, TDD, Clean Architecture, SOLID e Design Patterns" by Rodrigo Manguinho.

# Features 
The app has the following features:
- authentication ✅
- show surveys ✅
- show a single survey ✅
- save survey answer [?]

# Main goal of the project
Teach how to use Clean architecture patterns on Flutter projects with Test Driven Development(TDD).

# Folder architecture based on Clean Architecture

## Domain folder
The domain folder in this project has 3 folders, and is responsible for the Domain layer in the Clean Architecture
|entities|helpers|usecases|
|---|---|---|
|Has all entities definitions to be used in this app. In other words, these are the objects which Remote APIs DTOs should be mapped.|In this app this is where the domain errors, i.e, the errors regarding the app domain, will be placed.   | The domain usecases folder have the blueprint of the usecases to be implemented throughout the app. They will be later implemented in the data/usecases files.|

## Data folder 
The data folder in this project is responsible for the data layer in the Clean Architecture. Data Layer handles all data mutations and convertions to the application domain entities. It shoudl be common to find remote/local(offline) objects being mapped to entities.
This ensures that the data the remote domain and the app domain are separated. Inside of the data folder, there can be multiple folders according to a specific feature that the app should have, for example, a http client, a cache manager, camera and others. These folders in a similar fashion as the domain usecases, will contain only abstract classes that will be implemented later by the infra layer.

|cache| http|models|usecases|   |
|---|---|---|---|---|
|Cache is used in this app for allowing offline features. Here we have definitions for each behavior the cache should have.| In the http folder we have the definitions for http client features. Therefore, here we have the error definitions for http requests like bad request, not found and others. |Here lives all the files for remote/local entities, i.e blueprints classes that should have mappers to the domain entities classes. The logic to "map to another class" should be inside of there. This way we can isolate the class properties if the remote domain changes. |Usecases in the data layer have the implementations of the domain usecases folder. In other words, the data layer implementations will literally "implements" an interface or an abstract class which is points to a behavior required by the app.|   |


### Couple testing hints

Mock
Should be used when you only want the returned value of a method/function, but it is not required to get the returned value inside of the test scope. 

Spy
A Spy is used when the developer needs to get the returned value and change it to mock for different situations.

Stub
Test doubles or stubs are used to mock the returned value of something but it is not required to get this returned value inside the test scope.
Mockar o resultado e não está interessado em capturar nada
