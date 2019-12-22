# Changelog

2019-12-13 Eric Lau

    * remove admin dart files
    * migrate project to AndroidX
    * remove deprecated Flutter widgets

2019-12-14 Eric Lau

    * reorganize http testing
    * test secret apikeys
    * style welcome screen

2019-12-14 Ray Lee

    * added proposal, event, forum post, and comment skeleton classes

2019-12-15 Eric Lau

    * disconnect Firebase from sign in
    * add proposal display with title and description
    * add flutter retrieval of plaintext secret file
    * style sign in screen
    * add temporary delete proposals method

2019-12-15 Ray Lee

    * added file dependencies
    * added Map functions
    * converted ProposalPage into Stateful Widget
    * implemented making proposals through POST request

2019-12-21 ray. lee.

    * made register and login work
    * worked on encrypting passwords but removed this feature upon kaz's reminder that we are connecting through HTTPS anyways

2019-12-22 Eric Lau

    * clean up import mess
    * remove app side encryption

2019-12-22 ray. lee.

    * made voting semi-work