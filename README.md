Delphi StatHat
==============

Delphi library for StatHat API.

### How to Use

Just add StatHat to your uses clause and call one of its methods:

```delphi
    EzPostValue('load average', 'YOUR_API_KEY', 0.92);
    EzPostCount('messages sent - female to male', 'YOUR_API_KEY', 13);
```

All calls are async.

### To Do

- HTTPS support
- Offline support
