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
    * add back button to auth pages
    * reformat sign in page
    * toggle password obscurity
    * remove app side encryption
    * fix rendering overflow on pop to welcome
    * style sign up page

2019-12-22 ray. lee.

    * made voting semi-work

2019-12-23 Eric Lau

    * display forum cards
    * generalize getting headers

2019-12-23 ray. lee.

    * made voting secure (i think), now the button bar goes null (grays out) upon pressing either 'Yea' or 'Nay'. if the phone lags out and a second vote request went thru, kaz's api check (prevents duplicate voting records in his db votes table) will catch the error. after a user has voted on a proposal, if they choose to pop the page and go back, they no longer see the voting buttons and only see their past vote choice.
    * created a new file to replace proposal page dart file to clean things up; im pushing both files then deleting the old file and then pushing so the old file stays on our commit history record.

2019-12-24 Eric Lau

    * remove comments and unnecessary methods
    * refactor authentication buttons
    * remove unneeded variable from toMap functions
    * remove need for toMap functions all together
    * remove register object and transfer proposal to proposalcard
    * remodel forum streaming

2019-12-24 ray. lee.

    * helped erc clean up
    * added proper language choice upon register and send the correct ISO 639-1 language code to API

2019-12-30 Eric Lau

    * import cleanup
    * remove firebase remnants


2020-01-02 Eric Lau

    * fix login for wrong password
    * implement pull to refresh on screens

2020-01-03 Eric Lau

    * show SocketError on screens without internet
    * remove extraneous files and code