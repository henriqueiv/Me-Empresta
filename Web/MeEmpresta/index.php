<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
        <link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.min.css">
        <link rel="stylesheet" href="http://bootsnipp.com/dist/bootsnipp.min.css?ver=70eabcd8097cd299e1ba8efe436992b7">
    </head>
    <body>
        <form class="form-horizontal">
            <fieldset>

                <!-- Form Name -->
                <legend>Cadastrar empréstimo</legend>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="textDescricao">Descrição</label>  
                    <div class="col-md-6">
                        <input id="textDescricao" name="textDescricao" type="text" placeholder="descrição" class="form-control input-md" required="">

                    </div>
                </div>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="textPraQuem">Pra quem</label>  
                    <div class="col-md-6">
                        <input id="textPraQuem" name="textPraQuem" type="text" placeholder="pra quem?" class="form-control input-md" required="">

                    </div>
                </div>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="textDataEmprestimo">Data empréstimo</label>  
                    <div class="col-md-6">
                        <input id="textDataEmprestimo" name="textDataEmprestimo" type="text" placeholder="data de empréstimo" class="form-control input-md" required="">

                    </div>
                </div>

                <!-- Text input-->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="textDataDevolucao">Data devolução</label>  
                    <div class="col-md-6">
                        <input id="textDataDevolucao" name="textDataDevolucao" type="text" placeholder="data de devolução" class="form-control input-md" required="">

                    </div>
                </div>

                <!-- File Button --> 
                <div class="form-group">
                    <label class="col-md-4 control-label" for="imgBtn">Imagem</label>
                    <div class="col-md-4">
                        <input id="imgBtn" name="imgBtn" class="input-file" type="file">
                    </div>
                </div>

                <!-- Button -->
                <div class="form-group">
                    <label class="col-md-4 control-label" for="saveBtn"></label>
                    <div class="col-md-4">
                        <button id="saveBtn" name="saveBtn" class="btn btn-success">Salvar</button>
                    </div>
                </div>
            </fieldset>
        </form>
    </body>
</html>