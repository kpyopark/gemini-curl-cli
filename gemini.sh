#!/bin/bash

# 토큰 저장 파일 위치 설정
TOKEN_FILE="/tmp/gcloud_access_token"
TOKEN_TIMESTAMP_FILE="/tmp/gcloud_token_timestamp"

# 토큰이 유효한지 확인하는 함수
check_token_validity() {
    if [ ! -f "$TOKEN_FILE" ] || [ ! -f "$TOKEN_TIMESTAMP_FILE" ]; then
        return 1
    fi
    
    # 현재 시간과 토큰 생성 시간의 차이를 계산 (초 단위)
    current_time=$(date +%s)
    token_time=$(cat "$TOKEN_TIMESTAMP_FILE")
    time_diff=$((current_time - token_time))
    
    # 토큰 유효 시간을 50분(3000초)으로 설정
    if [ $time_diff -gt 3000 ]; then
        return 1
    fi
    
    return 0
}

# 액세스 토큰 가져오기
get_access_token() {
    if check_token_validity; then
        cat "$TOKEN_FILE"
    else
        # 새 토큰을 얻어서 파일에 저장
        new_token=$(gcloud auth print-access-token)
        echo "$new_token" > "$TOKEN_FILE"
        date +%s > "$TOKEN_TIMESTAMP_FILE"
        echo "$new_token"
    fi
}

# 1. 모든 명령행 인자를 하나의 문자열로 결합
INPUT_TEXT="${@:1}"

# 2. 액세스 토큰을 얻습니다
ACCESS_TOKEN=$(get_access_token)

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# .env 파일을 스크립트 디렉토리 기준으로 읽습니다
source "${SCRIPT_DIR}/.env"
MODEL_ID="gemini-1.5-flash-001"

# 4. API 엔드포인트 URL을 구성합니다
API_ENDPOINT="https://${LOCATION}-aiplatform.googleapis.com/v1/projects/${PROJECT_ID}/locations/${LOCATION}/publishers/google/models/${MODEL_ID}:generateContent"

# 5. 입력 텍스트를 JSON 형식으로 이스케이프 처리
ESCAPED_TEXT=$(echo "$INPUT_TEXT" | jq -Rs '.')

# 6. curl로 API를 호출하고 jq를 사용하여 응답 파싱
curl -s -X POST \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  "${API_ENDPOINT}" \
  -d '{
    "contents": [{
        "role": "user",
        "parts": [{
                "text": '"$ESCAPED_TEXT"'
        }]
     }],
    "system_instruction": { "parts" : [{ "text" : "You are a system engineer. You have to respond the answer for the given question shortly and concisely." }] },
    "generationConfig": {
      "temperature": 0.4,
      "maxOutputTokens": 8192,
      "topP": 0.95,
      "topK": 40
    }
  }' | jq -r '.candidates[0].content.parts[0].text'
