# Pokedex

## Descrição
Criar uma Pokedex utilizando a PokeAPi V2, mostrando uma tela com uma lista de Pokemons e os detalhes de cada Pokemon quando um deles é selecionado na lista.

## Requisitos 
### Tela com lista de Pokemons
- [ ] Busca por ID ou Nome utilizando o Search Controller
- [ ] Paginação com endless scrolling
- [ ] Foto default do Pokémon na listagem

### Tela de detalhes
- [ ] Nome e ID
- [ ] Carrossel com as fotos disponíveis do Pokémon
- [ ] View com os stats do Pokémon (hp, attack, defense, special attack, special, defense, speed)
- [ ] Exibir suas Habilidades (Run Away, Adaptability, Synchronize etc)
- [ ] Ao tocar em uma habilidade, exibir um modal com a descrição
- [ ] Exibir seus tipos (electric, ground, water, fire etc)
- [ ] Ao tocar em um tipo, exibir a lista dos Pokémons desse mesmo tipo
- [ ] Exibir a cadeia de evolução do Pokémon
- [ ] Exibir um picker que permita selecionar as variações do Pokémon (ao selecionar uma variação, o app deve carregar automaticamente os dados da variação selecionada).

## Requisitos Técnicos
- [ ] Desenvolva em Swift
- [ ] Utilizar alguma arquitetura de projeto (MVC, MVVM, Clean etc)
- [ ] Utilizar Alamofire para realizar os request às API's
- [ ] Utilizar o protocolo nativo para mapping de JSON (Codable)
- [ ] Tratar erros nas chamadas
- [ ] Não utilizar nenhum wrapper para a Pokémon API

## Requisitos Extra
- [ ] Testes unitários e instrumentados
- [ ] Cache das imagens e dos requests para APIs
- [ ] Utilizar Custom View Controller Transitions
- [ ] Seguir as guidelines do Human Interface Guidelines da Apple
- [ ] Conseguir as imagens dos posters e personagens de alguma API pública
- [ ] Construir layouts com Auto Layout
- [ ] Trabalhar offline (cache dos dados)
- [ ] Utilizar RxSwift