# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:1.12.5-stretch AS build-env

RUN apt-get update && apt-get -y install make git
ENV GO111MODULE=on
WORKDIR /go/src/log-generator

COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN make

FROM busybox
COPY --from=build-env /go/src/log-generator/bin/logs-generator /

ENV LOGS_GENERATOR_LINES_TOTAL 1
ENV LOGS_GENERATOR_DURATION 1s
ENV LOGS_GENERATION_MAX_KB=400 

CMD ["sh", "-c", "/logs-generator  --log-lines-total=${LOGS_GENERATOR_LINES_TOTAL} --run-duration=${LOGS_GENERATOR_DURATION} --log-lines-max-kb=${LOGS_GENERATOR_MAX_KB}"]
