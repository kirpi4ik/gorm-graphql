# Gorm GraphQL

## An automatic GraphQL schema generator for GORM

Original code of this project you can find [here](https://github.com/grails/gorm-graphql). Original project was outdated
for more than 2 years without merging open PRs which unfortunatiley makes that repository useless.

The main purpose :

- Keep grails and graphql dependencies up to date
- Push the latest version to the maven central

### Dependencies

- [Graphql Java](https://github.com/graphql-java/graphql-java)

### Usage

grails plugin :
```xml
<dependency>
    <groupId>org.myhab.tools</groupId>
    <artifactId>gorm-graphql-grails-plugin</artifactId>
    <version>2.1-SNAPSHOT</version>
</dependency>
```
gorm-graphql
```xml
<dependency>
    <groupId>org.myhab.tools</groupId>
    <artifactId>gorm-graphql</artifactId>
    <version>2.1-SNAPSHOT</version>
</dependency>
```