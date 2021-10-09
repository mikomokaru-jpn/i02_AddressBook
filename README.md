## ios_S_AddressBook

<img src="http://mikomokaru.sakura.ne.jp/data/93/address_book0.png" alt="book0" title="book0" width="250">&nbsp;&nbsp;&nbsp;&nbsp;<img src="http://mikomokaru.sakura.ne.jp/data/93/address_book1.png" alt="book1" title="book1" width="250">

I made an app that behaves like iPhone app Contacts.It displays contacts. You can edit your contacts so change a name, zip code, address, and phone numbers and email addresses. And you can add and remove phone numbers and email addresses. Since it is a trial version, it does not cover all the functions such as adding and deleting contacts.

### some features

### Scroll and display an input control hidden behind the keyboard

When the keyboard is appered, If a text field is hidden behind it , move the scroll view upwards to display the text field so you can enter text.

<img src="http://mikomokaru.sakura.ne.jp/data/93/address_book2.png" alt="book2" title="book2" width="250">

### Confirm deletion of a cell of table view
When you tap a delete button to delete a phone number or email address, a delete confirmation button slides out. If you tap the button, the record will be deleted, and if you tap the area other than the button, the process will be cancelled.

<img src="http://mikomokaru.sakura.ne.jp/data/93/address_book3.png" alt="book3" title="book3" width="250">


### Enable / disable Update Button
When the text is changed, it is compared with the initially displayed text. Enable Update Button on Navigation Bar when there is a change. If the result of changing the text is the same as the initial display, the button is disabled because there is no need to update.

<img src="http://mikomokaru.sakura.ne.jp/data/93/address_book4.png" alt="book4" title="book4" width="250">

### View structure diagram（ViewControllerDetail）

<img src="http://mikomokaru.sakura.ne.jp/data/93/view_structure.png" alt="view_structure" title="view_structure" width="600">

