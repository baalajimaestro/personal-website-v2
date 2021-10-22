---
title: "Google Analytics, the bad guy behind bad PageSpeed Scores"
date: 2021-10-22T10:41:41+05:30
---

I am not bothered about the data being collected by Google, as an ardent user of Google in every way or the other.

And yet, I became a hater of Google Analytics today. All thanks to their script slowing down the site.

My company has been doing page speed analysis for the past few weeks on their websites, and this triggered my curiosity to check my own site's score.
It did fairly well, giving a 70 on mobile, I was kinda surprised how it is that bad, and Google safely hid gtag.js from being shown as the culprit.

My browser of choice, Firefox, basically killed gtag.js from running every time, so I haven't noticed any significant change. Same with my other browser
Vivaldi. When I installed Chrome for this specific purpose, I saw gtag.js take a significant loading time.

Nuking it off and rebuilding the site, bumped my score straight to 95, which seems astonishing.

As a result, I went with self-hosted shynet (https://github.com/milesmcc/shynet/) and it's now available at analytics.baalajimaestro.me.

My shynet instance respects DNT, and is also GDPR compliant, should you have any issues with it, feel free to message me on any of the contact options listed below.
