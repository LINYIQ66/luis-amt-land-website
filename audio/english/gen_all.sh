#!/bin/bash
KEY="sk_f9d8b1fd5f669e938eb435271600785bd4b1d3f7deeae040"
BASE="https://api.elevenlabs.io/v1/text-to-speech"
OUT="/var/www/3.luis.amt.land/audio/english"
mkdir -p "$OUT"

VOICES=("british-f:pFZP5JQG7iQjIQuC4Bku" "british-m:onwK4e9ZLuTAKqWW03F9" "american-f:21m00Tcm4TlvDq8ikWAM" "american-m:TxGEqnHWrfWFTfGW9XjX")

declare -A TEXTS
TEXTS[self-reliance]="To believe your own thought, to believe that what is true for you in your private heart is true for all men, that is genius. Speak your latent conviction, and it shall be the universal sense."
TEXTS[wuthering-heights]="He is more myself than I am. Whatever our souls are made of, his and mine are the same."
TEXTS[walden]="I went to the woods because I wished to live deliberately, to front only the essential facts of life, and see if I could not learn what it had to teach, and not, when I came to die, discover that I had not lived."
TEXTS[great-gatsby]="In my younger and more vulnerable years my father gave me some advice that I have been turning over in my mind ever since. Whenever you feel like criticizing anyone, just remember that all the people in this world have not had the advantages that you have had."
TEXTS[pride-prejudice]="It is a truth universally acknowledged, that a single man in possession of a good fortune, must be in want of a wife."
TEXTS[little-prince]="One sees clearly only with the heart. Anything essential is invisible to the eyes."
TEXTS[1984]="War is peace. Freedom is slavery. Ignorance is strength. Big Brother is watching you."
TEXTS[hamlet]="To be, or not to be, that is the question. Whether tis nobler in the mind to suffer the slings and arrows of outrageous fortune, or to take arms against a sea of troubles, and by opposing end them."
TEXTS[i-have-a-dream]="I have a dream that my four little children will one day live in a nation where they will not be judged by the color of their skin but by the content of their character."
TEXTS[gettysburg]="Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal."
TEXTS[steve-jobs]="Your time is limited, so don't waste it living someone else's life. Don't be trapped by dogma, which is living with the results of other people's thinking."
TEXTS[frankenstein]="I am malicious and miserable because I am wretched. Be not merciful to me, but fulfill my wishes."
TEXTS[origin-species]="There is grandeur in this view of life, with its several powers, having been originally breathed into a few forms or into one; and that, whilst this planet has gone cycling on according to the fixed law of gravity, from so simple a beginning endless forms most beautiful and most wonderful have been, and are being, evolved."
TEXTS[brief-history]="Even if there is only one possible unified theory, it is just a set of rules and equations. What is it that breathes fire into the equations and makes a universe for them to describe?"
TEXTS[road-not-taken]="Two roads diverged in a wood, and I took the one less traveled by, and that has made all the difference."
TEXTS[sonnet-18]="Shall I compare thee to a summer's day? Thou art more lovely and more temperate. Rough winds do shake the darling buds of May, and summer's lease hath all too short a date."
TEXTS[if]="If you can keep your head when all about you are losing theirs and blaming it on you; if you can trust yourself when all men doubt you, but make allowance for their doubting too."
TEXTS[meditations]="The happiness of your life depends upon the quality of your thoughts: therefore, guard accordingly, and take care that you entertain no notions unsuitable to virtue and reasonable nature."
TEXTS[nicomachean]="We are what we repeatedly do. Excellence, then, is not an act, but a habit."
TEXTS[art-of-war]="Appear weak when you are strong, and strong when you are weak. The supreme art of war is to subdue the enemy without fighting."
TEXTS[declaration]="We hold these truths to be self-evident, that all men are created equal, that they are endowed by their Creator with certain unalienable Rights, that among these are Life, Liberty and the pursuit of Happiness."
TEXTS[letter-birmingham]="Injustice anywhere is a threat to justice everywhere. We are caught in an inescapable network of mutuality, tied in a single garment of destiny."
TEXTS[think-grow]="Whatever the mind of man can conceive and believe, it can achieve. Thoughts are things, and powerful things at that when mixed with definiteness of purpose."
TEXTS[how-win-friends]="You can make more friends in two months by becoming interested in other people than you can in two years by trying to get other people interested in you."
TEXTS[sapiens]="The real difference between us and chimpanzees is the mysterious glue that enables millions of humans to cooperate effectively. This mythical glue is made of stories, not genes."
TEXTS[to-kill-mockingbird]="You never really understand a person until you consider things from his point of view, until you climb into his skin and walk around in it."
TEXTS[brave-new-world]="Words can be like X-rays if you use them properly — they'll go through anything. You read and you're pierced."
TEXTS[cosmos]="The cosmos is within us. We are made of star-stuff. We are a way for the universe to know itself."

DONE=0
FAIL=0
TOTAL=112

for ID in "${!TEXTS[@]}"; do
  TEXT="${TEXTS[$ID]}"
  for VPAIR in "${VOICES[@]}"; do
    VNAME="${VPAIR%%:*}"
    VID="${VPAIR##*:}"
    FNAME="${ID}_${VNAME}.mp3"
    FPATH="${OUT}/${FNAME}"
    
    if [ -f "$FPATH" ] && [ $(stat -c%s "$FPATH") -gt 1000 ]; then
      DONE=$((DONE+1))
      continue
    fi
    
    HTTP_CODE=$(curl -s -o "$FPATH" -w "%{http_code}" \
      -X POST "${BASE}/${VID}" \
      -H "xi-api-key: ${KEY}" \
      -H "Content-Type: application/json" \
      -d "{\"text\":\"${TEXT}\",\"model_id\":\"eleven_multilingual_v2\",\"output_format\":\"mp3_44100_128\"}")
    
    if [ "$HTTP_CODE" = "200" ]; then
      DONE=$((DONE+1))
      SIZE=$(stat -c%s "$FPATH" 2>/dev/null || echo 0)
      echo "[${DONE}/${TOTAL}] ✅ ${FNAME} (${SIZE} bytes)"
    else
      FAIL=$((FAIL+1))
      echo "[${DONE}/${TOTAL}] ❌ ${FNAME} HTTP ${HTTP_CODE}"
      [ "$HTTP_CODE" = "429" ] && sleep 10
    fi
    sleep 0.5
  done
done

echo ""
echo "=== DONE: ${DONE}/${TOTAL} | Failed: ${FAIL} ==="
