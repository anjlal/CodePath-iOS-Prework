# Pre-work - *Tippy*

**Tippy** is a tip calculator application for iOS.

Submitted by: **Jonathan Como**

Time spent: **8** hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage. (edit: instead of changing the tip percentage, remembers the tip)

The following **optional** features are implemented:
* [x] UI animations
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

- [x] Display splitting the bill across parties of up to 4 people
- [x] Use a pan gesture to slide the tip amount
- [x] Use a tap gesture to toggle between displaying the tip and total

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.giphy.com/3o7TKzu4SEBvSvLKlW.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

When doing the split across parties of up to 4, I found myself creating a label for each one
and wiring it up separately. I feel like there is a way to DRY it up.

## License

    Copyright 2016 Jonathan Como

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
