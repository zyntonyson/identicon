%% -------------------------------------------------------------------
%%
%% Copyright (c) 2018 Luis Rascao.  All Rights Reserved.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------

-module(string_compat).
-author("Luis Rascao <luis.rascao@gmail.com>").

-export([strip/1, strip/2, strip/3,
         tokens/2]).

%--------------------------------------------
% API
%--------------------------------------------
-ifdef(string_module).
strip(String) ->
    string:trim(String).
-else.
strip(String) ->
    string:strip(String).
-endif.

-ifdef(string_module).
strip(String, Direction) ->
    string:trim(String, direction(Direction)).
-else.
strip(String, Direction) ->
    string:strip(String, direction(Direction)).
-endif.

-ifdef(string_module).
strip(String, Direction, Char) ->
    string:trim(String, direction(Direction), [Char]).
-else.
strip(String, Direction, Char) ->
    string:strip(String, direction(Direction), Char).
-endif.

-ifdef(string_module).
tokens(String, SeparatorList) ->
    string:lexemes(String, SeparatorList).
-else.
tokens(String, SeparatorList) ->
    string:tokens(String, SeparatorList).
-endif.

%--------------------------------------------
% Private methods
%--------------------------------------------
-ifdef(string_module).
direction(left) -> leading;
direction(right) -> trailing;
direction(both) -> both.
-else.
direction(left) -> left;
direction(right) -> right;
direction(both) -> both.
-endif.

